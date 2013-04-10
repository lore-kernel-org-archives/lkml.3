Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3DJGQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:16:30 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50335 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3DJGQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:16:28 -0400
Date: Tue, 9 Apr 2013 23:16:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Toshi Kani <toshi.kani@hp.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [PATCH v2 2/3] resource: Add release_mem_region_adjustable()
In-Reply-To: <1365440996-30981-3-git-send-email-toshi.kani@hp.com>
Message-ID: <alpine.DEB.2.02.1304092315180.3916@chino.kir.corp.google.com>
References: <1365440996-30981-1-git-send-email-toshi.kani@hp.com> <1365440996-30981-3-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013, Toshi Kani wrote:

> Added release_mem_region_adjustable(), which releases a requested
> region from a currently busy memory resource.  This interface
> adjusts the matched memory resource accordingly even if the
> requested region does not match exactly but still fits into.
> 
> This new interface is intended for memory hot-delete.  During
> bootup, memory resources are inserted from the boot descriptor
> table, such as EFI Memory Table and e820.  Each memory resource
> entry usually covers the whole contigous memory range.  Memory
> hot-delete request, on the other hand, may target to a particular
> range of memory resource, and its size can be much smaller than
> the whole contiguous memory.  Since the existing release interfaces
> like __release_region() require a requested region to be exactly
> matched to a resource entry, they do not allow a partial resource
> to be released.
> 
> There is no change to the existing interfaces since their restriction
> is valid for I/O resources.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Should this emit a warning for attempting to free a non-existant region 
like __release_region() does?

I think it would be better to base this off my patch and surround it with 
#ifdef CONFIG_MEMORY_HOTREMOVE as suggested by Andrew.  There shouldn't be 
any conflicts.
