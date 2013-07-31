Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3GaQoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3GaQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:44:19 -0400
Date: Wed, 31 Jul 2013 12:43:52 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Hillf Danton <dhillf@gmail.com>
Message-ID: <1375289032-ksc4vltc-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130731051221.GK2548@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075929-6119-16-git-send-email-iamjoonsoo.kim@lge.com>
 <1375124737-9w10y4c4-mutt-n-horiguchi@ah.jp.nec.com>
 <1375125555-yuwxqz39-mutt-n-horiguchi@ah.jp.nec.com>
 <20130731051221.GK2548@lge.com>
Subject: Re: [PATCH 15/18] mm, hugetlb: move up anon_vma_prepare()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130731051221.GK2548@lge.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 02:12:21PM +0900, Joonsoo Kim wrote:
> On Mon, Jul 29, 2013 at 03:19:15PM -0400, Naoya Horiguchi wrote:
> > On Mon, Jul 29, 2013 at 03:05:37PM -0400, Naoya Horiguchi wrote:
> > > On Mon, Jul 29, 2013 at 02:32:06PM +0900, Joonsoo Kim wrote:
> > > > If we fail with a allocated hugepage, it is hard to recover properly.
> > > > One such example is reserve count. We don't have any method to recover
> > > > reserve count. Although, I will introduce a function to recover reserve
> > > > count in following patch, it is better not to allocate a hugepage
> > > > as much as possible. So move up anon_vma_prepare() which can be failed
> > > > in OOM situation.
> > > > 
> > > > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > > 
> > > Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > 
> > Sorry, let me suspend this Reviewed for a question.
> > If alloc_huge_page failed after we succeeded anon_vma_parepare,
> > the allocated anon_vma_chain and/or anon_vma are safely freed?
> > Or don't we have to free them?
> 
> Yes, it will be freed by free_pgtables() and then unlink_anon_vmas()
> when a task terminate. So, we don't have to free them.

OK, thanks for clarification.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
