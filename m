Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935037AbaKLCDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:03:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43415 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbaKLCDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:03:02 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5462BFBA.4010207@jp.fujitsu.com>
Date: Wed, 12 Nov 2014 11:02:34 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>
CC: <kamezawa.hiroyu@jp.fujitsu.com>, "'Minchan Kim'" <minchan@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>, <mgorman@suse.de>,
        <mina86@mina86.com>, "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH 1/2] mm: page_isolation: check pfn validity before access
References: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
In-Reply-To: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/06 17:08), Weijie Yang wrote:
> In the undo path of start_isolate_page_range(), we need to check
> the pfn validity before access its page, or it will trigger an
> addressing exception if there is hole in the zone.
>
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> ---

Looks good to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   mm/page_isolation.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index d1473b2..3ddc8b3 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -137,8 +137,11 @@ int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
>   undo:
>   	for (pfn = start_pfn;
>   	     pfn < undo_pfn;
> -	     pfn += pageblock_nr_pages)
> -		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
> +	     pfn += pageblock_nr_pages) {
> +		page = __first_valid_page(pfn, pageblock_nr_pages);
> +		if (page)
> +			unset_migratetype_isolate(page, migratetype);
> +	}
>
>   	return -EBUSY;
>   }
>


