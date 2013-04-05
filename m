Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162995Ab3DEWSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:18:07 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:50124 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162979Ab3DEWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:18:04 -0400
Message-ID: <515F4D9A.3060009@gmail.com>
Date: Fri, 05 Apr 2013 18:18:02 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 07/10] mbind: add hugepage migration code to mbind()
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-8-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363983835-20184-8-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1277,14 +1279,10 @@ static long do_mbind(unsigned long start, unsigned long len,
>  	if (!err) {
>  		int nr_failed = 0;
>  
> -		if (!list_empty(&pagelist)) {
> -			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
> -			nr_failed = migrate_pages(&pagelist, new_vma_page,
> +		WARN_ON_ONCE(flags & MPOL_MF_LAZY);

???
MPOL_MF_LAZY always output warn? It seems really insane.


