Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3HVRBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:01:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab3HVRBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:01:09 -0400
Date: Thu, 22 Aug 2013 13:00:37 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1377190837-ry9saqra-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1377189788-xv5ewgmb-mutt-n-horiguchi@ah.jp.nec.com>
References: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1377164907-24801-3-git-send-email-liwanp@linux.vnet.ibm.com>
 <1377189788-xv5ewgmb-mutt-n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 3/6] mm/hwpoison: fix num_poisoned_pages error statistics
 for thp
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 12:43:08PM -0400, Naoya Horiguchi wrote:
> On Thu, Aug 22, 2013 at 05:48:24PM +0800, Wanpeng Li wrote:
> > There is a race between hwpoison page and unpoison page, memory_failure 
> > set the page hwpoison and increase num_poisoned_pages without hold page 
> > lock, and one page count will be accounted against thp for num_poisoned_pages.
> > However, unpoison can occur before memory_failure hold page lock and 
> > split transparent hugepage, unpoison will decrease num_poisoned_pages 
> > by 1 << compound_order since memory_failure has not yet split transparent 
> > hugepage with page lock held. That means we account one page for hwpoison
> > and 1 << compound_order for unpoison. This patch fix it by decrease one 
> > account for num_poisoned_pages against no hugetlbfs pages case.
> > 
> > Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> 
> I think that a thp never becomes hwpoisoned without splitting, so "trying
> to unpoison thp" never happens (I think that this implicit fact should be
> commented somewhere or asserted with VM_BUG_ON().)

> And nr_pages in unpoison_memory() can be greater than 1 for hugetlbfs page.
> So does this patch break counting when unpoisoning free hugetlbfs pages?

Sorry, the latter part of this remark was incorrect. Please ignore it.

- Naoya
