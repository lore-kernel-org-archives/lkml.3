Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3FCOfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:35:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299Ab3FCOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:35:07 -0400
Date: Mon, 03 Jun 2013 10:34:41 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <1370270081-pv4wkd99-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130603132641.GB18588@dhcp22.suse.cz>
References: <1369770771-8447-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1369770771-8447-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130603132641.GB18588@dhcp22.suse.cz>
Subject: Re: [PATCH v3 2/2] migrate: add migrate_entry_wait_huge()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130603132641.GB18588@dhcp22.suse.cz>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 03:26:41PM +0200, Michal Hocko wrote:
> On Tue 28-05-13 15:52:51, Naoya Horiguchi wrote:
> > When we have a page fault for the address which is backed by a hugepage
> > under migration, the kernel can't wait correctly and do busy looping on
> > hugepage fault until the migration finishes.
> > This is because pte_offset_map_lock() can't get a correct migration entry
> > or a correct page table lock for hugepage.
> > This patch introduces migration_entry_wait_huge() to solve this.
> > 
> > Note that the caller, hugetlb_fault(), gets the pointer to the "leaf"
> > entry with huge_pte_offset() inside which all the arch-dependency of
> > the page table structure are. So migration_entry_wait_huge() and
> > __migration_entry_wait() are free from arch-dependency.
> > 
> > ChangeLog v3:
> >  - use huge_pte_lockptr
> > 
> > ChangeLog v2:
> >  - remove dup in migrate_entry_wait_huge()
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Reviewed-by: Rik van Riel <riel@redhat.com>
> > Cc: stable@vger.kernel.org # 2.6.35
> 
> OK, this looks good to me and I guess you can safely replace
> huge_pte_lockptr by &(mm)->page_table_lock so you can implement this
> even without risky 1/2 of this series. The patch should be as simple as
> possible especially when it goes to the stable.

Yes, I agree.

> > Without 1/2 dependency
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks,
Naoya
