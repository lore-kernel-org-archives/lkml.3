Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaKRDZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:25:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40352 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaKRDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:25:28 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <546ABC02.4010905@jp.fujitsu.com>
Date: Tue, 18 Nov 2014 12:24:50 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "Larry Woodman" <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: do not overwrite reserved pages counter at show_mem()
References: <e34cbf786f7c16d4330889825aa5b13141cc085c.1415989668.git.aquini@redhat.com>
In-Reply-To: <e34cbf786f7c16d4330889825aa5b13141cc085c.1415989668.git.aquini@redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/15 3:34), Rafael Aquini wrote:
> Minor fixlet to perform the reserved pages counter aggregation
> for each node, at show_mem()
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> ---

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   lib/show_mem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/show_mem.c b/lib/show_mem.c
> index 0922579..5e25627 100644
> --- a/lib/show_mem.c
> +++ b/lib/show_mem.c
> @@ -28,7 +28,7 @@ void show_mem(unsigned int filter)
>   				continue;
>   
>   			total += zone->present_pages;
> -			reserved = zone->present_pages - zone->managed_pages;
> +			reserved += zone->present_pages - zone->managed_pages;
>   
>   			if (is_highmem_idx(zoneid))
>   				highmem += zone->present_pages;
> 


