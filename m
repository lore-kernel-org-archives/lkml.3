Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3ARUyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:54:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab3ARUyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:54:22 -0500
Date: Fri, 18 Jan 2013 15:54:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        ebiederm@xmission.com, cpw@sgi.com, Rik Van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH v1 0/3] kdump, vmcore: Map vmcore memory in direct
 mapping region
Message-ID: <20130118205413.GB10969@redhat.com>
References: <20130110115615.645.56499.stgit@localhost6.localdomain6>
 <20130117221348.GJ2237@redhat.com>
 <20130118.230659.282304499.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118.230659.282304499.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:06:59PM +0900, HATAYAMA Daisuke wrote:

[..]
> > These are impressive improvements. I missed the discussion on mmap().
> > So why couldn't we provide mmap() interface for /proc/vmcore. If that
> > works then application can select to mmap/unmap bigger chunks of file
> > (instead ioremap mapping/remapping a page at a time). 
> > 
> > And if application controls the size of mapping, then it can vary the
> > size of mapping based on available amount of free memory. That way if
> > somebody reserves less amount of memory, we could still dump but with
> > some time penalty.
> > 
> 
> mmap() needs user-space page table in addition to kernel-space's,

[ CC Rik van Riel] 

I was chatting with Rik and it does not look like that there is any
fundamental requirement that range of pfn being mapped in user tables
has to be mapped in kernel tables too. Did you run into specific issue.

> and
> it looks that remap_pfn_range() that creates the user-space page
> table, doesn't support large pages, only 4KB pages.

This indeed looks like the case. May be we can enahnce remap_pfn_range()
to take an argument and create larger size mappings.

> If mmaping small
> chunks only for small memory programming, then we would again face the
> same issue as with ioremap.

Even if it is 4KB pages, I think it will still be faster than current
interface. Because we will not be issuing these many tlb flushes.
(Assuming makedumpfile has been modified to map/unap large areas of
/proc/vmcore).

Thanks
Vivek
