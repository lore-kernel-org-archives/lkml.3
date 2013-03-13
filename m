Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab3CMQXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:23:24 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:42495 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3CMQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:23:23 -0400
Message-ID: <5140A7F2.5080203@xs4all.nl>
Date: Wed, 13 Mar 2013 17:23:14 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.6.11: khubd issue SLAB related?
References: <5139E36A.5000109@xs4all.nl> <alpine.DEB.2.02.1303111410470.4160@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1303111410470.4160@chino.kir.corp.google.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-11 22:23, David Rientjes wrote:
> On Fri, 8 Mar 2013, Udo van den Heuvel wrote:
> 
>> [3663200.799579] SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
>> [3663200.799581]   cache: size-65536, object size: 65536, order: 4
>> [3663200.799583]   node 0: slabs: 6/6, objs: 6/6, free: 0
>> [3663200.799585] pwc: Oops, could not allocate memory for pwc_device.
> 
> You have memory freed, but like your earlier page allocation failure on 
> mount, it is too fragmented.  This is an order-4 page allocation, the 
> kmalloc() of struct pwc_device, and you don't even have any order-3 pages 
> that are available.  Are you running with CONFIG_COMPACTION enabled?

Yes.

> If not, enable it and try again, or get root and manually try to 
> defragment memory by doing echo 1 > /proc/sys/vm/compact_memory.

This needs to be done regularly, I assume?

> If so, try killing a memory hogging process to free some memory and 
> attempt to get some higher order pages available.

It's a 8GB box (7.5GB available to software) with modest load. Mostly
email & web browsing, some torrents, nntp stuff, etc. Nothing weird.
Around 4.8G in buffers/cache right now.

Why is this issue occurring?
Why did I not see this in the past?

Udo
