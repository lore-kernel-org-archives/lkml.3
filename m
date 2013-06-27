Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3F0Ssx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3F0Ssv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:48:51 -0400
Date: Thu, 27 Jun 2013 14:48:13 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <1372358893-ocx0hyti-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <87a9ml3y8k.wl%satoru.takeuchi@gmail.com>
References: <20130618161725.912524266@linuxfoundation.org>
 <20130618161730.095209184@linuxfoundation.org>
 <87a9ml3y8k.wl%satoru.takeuchi@gmail.com>
Subject: Re: [ 29/48] mm: migration: add migrate_entry_wait_huge()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <87a9ml3y8k.wl%satoru.takeuchi@gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takeuchi-san,
Sorry for the late response, I was on vacation this 2 weeks.

And as your mentioned in the later discussion in this thread,
the problem you worry about does not come from this patch.
So this patch is ok as it is.

Thanks,
Naoya Horiguchi

On Thu, Jun 20, 2013 at 06:52:43PM +0900, Satoru Takeuchi wrote:
> Hi Naoya,
> 
> At Tue, 18 Jun 2013 09:17:55 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > 3.9-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > 
> > commit 30dad30922ccc733cfdbfe232090cf674dc374dc upstream.
> > 
> > When we have a page fault for the address which is backed by a hugepage
> > under migration, the kernel can't wait correctly and do busy looping on
> > hugepage fault until the migration finishes.  As a result, users who try
> > to kick hugepage migration (via soft offlining, for example) occasionally
> > experience long delay or soft lockup.
> > 
> > This is because pte_offset_map_lock() can't get a correct migration entry
> > or a correct page table lock for hugepage.  This patch introduces
> > migration_entry_wait_huge() to solve this.
> 
> I suspect that this code doesn't work correctly on i686 box with CONFIG_HIGHPTE.
> If we call hugetlb_fault() -> migration_entry_wait_huge() -> __migration_entry_wait(),
> this function tries to kunmap pte, in this case pte is not-kmapped pmd, via pte_unmap_unlock().
> If CONFIG_DEBUG_HIGHMEM is also enabled, it results in BUG_ON() at __kunmap_atomic().
> 
> Correct me if I'm wrong.
