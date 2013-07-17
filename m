Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab3GQSGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:06:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab3GQSGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:06:14 -0400
Date: Wed, 17 Jul 2013 14:06:03 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        kirill.shutemov@linux.intel.com
Message-ID: <1374084363-9zlarbf2-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1374078950-8o0ev16q-mutt-n-horiguchi@ah.jp.nec.com>
References: <1374012587-whdyhveh-mutt-n-horiguchi@ah.jp.nec.com>
 <1374078950-8o0ev16q-mutt-n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] mm/swap.c: clear PageActive before adding pages onto
 unevictable list (Re: 3.11.0-rc1: kernel BUG at mm/migrate.c:458 in page
 migration)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1374078950-8o0ev16q-mutt-n-horiguchi@ah.jp.nec.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 12:35:50PM -0400, Naoya Horiguchi wrote:
...
> ---
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Wed, 17 Jul 2013 11:49:56 -0400
> Subject: [PATCH] mm/swap.c: clear PageActive before adding pages onto
>  unevictable list
> 
> As a result of v3.10-3600-g13f7f78 "mm: pagevec: defer deciding which LRU
> to add a page to until pagevec drain time," pages on unevictable lists can
> have both of PageActive and PageUnevictable set. This is not only confusing,
> but also corrupts page migration and shrink_[in]active_list.
> 
> This patch fixes the problem by adding ClearPageActive before adding pages
> into unevictable list. It also cleans up VM_BUG_ONs.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: stable@vger.kernel.org # 3.10

No need to send to stable because the problem occurs after 3.10, sorry.

Naoya Horiguchi
