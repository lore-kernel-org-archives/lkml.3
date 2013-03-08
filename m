Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab3CHHBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:01:37 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58847 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab3CHHBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:01:35 -0500
Date: Thu, 7 Mar 2013 23:01:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 14/14] x86, mm: Put pagetable on local node ram
Message-ID: <20130308070130.GM14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-15-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-15-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:58:40PM -0800, Yinghai Lu wrote:
> If node with ram is hotplugable, local node mem for page table and vmemmap
> should be on that node ram.
> 
> This patch is some kind of refreshment of
> | commit 1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
> | Date:   Mon Dec 27 16:48:17 2010 -0800
> |
> |    x86-64, numa: Put pgtable to local node memory
> That was reverted before.
> 
> We have reason to reintroduce it to make memory hotplug work.
> 
> Split calling of init_mem_mapping into early_initmem_info
> for nodes after we get numa info there.
> 
> First node will be low range.
> Need to rework alloc_low_pages to alloc page table in following order:
> 	BRK, local node, low range
> 
> Still only load_cr3 one time, otherwise we would break xen 64bit again.

Hmmm... can you please split this patch further?  init_mem_mapping()
change can be separated, no?  Also, comments are disturbingly missing.
How are other people reading the code supposed to know what it's
trying to achieve why and how?  Hmmm... we're also likely to end up
with smaller mapping for misaligned NUMA configurations (I think my
test machine is like that).  Is it guaranteed that the top level ends
up in the first node?  It really needs documentation.

Thanks.

-- 
tejun
