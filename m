Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab3GQSIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab3GQSId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:08:33 -0400
Date: Wed, 17 Jul 2013 14:08:25 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Message-ID: <1374084505-2en57dv0-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130717180249.19F1BE0090@blue.fi.intel.com>
References: <1374012587-whdyhveh-mutt-n-horiguchi@ah.jp.nec.com>
 <1374078950-8o0ev16q-mutt-n-horiguchi@ah.jp.nec.com>
 <20130717180249.19F1BE0090@blue.fi.intel.com>
Subject: Re: [PATCH] mm/swap.c: clear PageActive before adding pages onto
 unevictable list (Re: 3.11.0-rc1: kernel BUG at mm/migrate.c:458 in page
 migration)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130717180249.19F1BE0090@blue.fi.intel.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 09:02:49PM +0300, Kirill A. Shutemov wrote:
...
> > ---
> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Date: Wed, 17 Jul 2013 11:49:56 -0400
> > Subject: [PATCH] mm/swap.c: clear PageActive before adding pages onto
> >  unevictable list
> > 
> > As a result of v3.10-3600-g13f7f78 "mm: pagevec: defer deciding which LRU
> > to add a page to until pagevec drain time," pages on unevictable lists can
> > have both of PageActive and PageUnevictable set. This is not only confusing,
> > but also corrupts page migration and shrink_[in]active_list.
> > 
> > This patch fixes the problem by adding ClearPageActive before adding pages
> > into unevictable list. It also cleans up VM_BUG_ONs.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Cc: stable@vger.kernel.org # 3.10
> 
> Looks good to me.
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Thanks.

> One more patch related to the topic:
> 
> https://lkml.org/lkml/2013/7/15/140

Yes, that's why I added CC to you :)

Naoya
