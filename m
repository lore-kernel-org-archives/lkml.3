Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaFKWIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:08:44 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51357 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaFKWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:08:42 -0400
Date: Wed, 11 Jun 2014 15:08:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
cc: gregkh@linuxfoundation.org, laijs@cn.fujitsu.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Wang Nan <wangnan0@huawei.com>
Subject: Re: Proposal to realize hot-add *several sections one time*
In-Reply-To: <53981D81.5060708@huawei.com>
Message-ID: <alpine.DEB.2.02.1406111503050.27885@chino.kir.corp.google.com>
References: <53981D81.5060708@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Zhang Zhen wrote:

> Hi,
> 
> Now we can hot-add memory by
> 
> % echo start_address_of_new_memory > /sys/devices/system/memory/probe
> 
> Then, [start_address_of_new_memory, start_address_of_new_memory +
> memory_block_size] memory range is hot-added.
> 
> But we can only hot-add *one section one time* by this way.
> Whether we can add an argument on behalf of the count of the sections to add ?
> So we can can hot-add *several sections one time*. Just like:
> 

Not necessarily true, it depends on sections_per_block.  Don't believe 
Documentation/memory-hotplug.txt that suggests this is only for powerpc, 
x86 and sh allow this interface as well.

> % echo start_address_of_new_memory count_of_sections > /sys/devices/system/memory/probe
> 
> Then, [start_address_of_new_memory, start_address_of_new_memory +
> count_of_sections * memory_block_size] memory range is hot-added.
> 
> If this proposal is reasonable, i will send a patch to realize it.
> 

The problem is knowing how much memory is being onlined so that you can 
definitively determine what count_of_sections should be.  The number of 
pages per memory section depends on PAGE_SIZE and SECTION_SIZE_BITS which 
differ depending on the architectures that support this interface.  So if 
you support count_of_sections, it would return errno even though you have 
onlined some sections.
