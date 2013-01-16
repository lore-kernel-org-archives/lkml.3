Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab3APBjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:39:45 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45012 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab3APBjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:39:44 -0500
Message-ID: <50F604D4.407@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 17:39:32 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 17/17] mm/compaction: use zone_end_pfn()
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com> <1358295894-24167-18-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1358295894-24167-18-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011601-9360-0000-0000-00000F4036C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 04:24 PM, Cody P Schafer wrote:
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 1b52528..ea66be3 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -85,7 +85,7 @@ static inline bool isolation_suitable(struct compact_control *cc,
>  static void __reset_isolation_suitable(struct zone *zone)
>  {
>  	unsigned long start_pfn = zone->zone_start_pfn;
> -	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
> +	unsigned long end_pfn = zone_end_pfn(zone);
>  	unsigned long pfn;
> 
>  	zone->compact_cached_migrate_pfn = start_pfn;
> @@ -663,7 +663,7 @@ static void isolate_freepages(struct zone *zone,
>  	 */
>  	high_pfn = min(low_pfn, pfn);
> 
> -	z_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
> +	z_end_pfn = zone_end_pfn(zone);
> 
>  	/*
>  	 * Isolate free pages until enough are available to migrate the
> @@ -920,7 +920,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>  {
>  	int ret;
>  	unsigned long start_pfn = zone->zone_start_pfn;
> -	unsigned long end_pfn = zone->zone_start_pfn + zone->spanned_pages;
> +	unsigned long end_pfn = zone_end_pfn(zone);
> 
>  	ret = compaction_suitable(zone, cc->order);
>  	switch (ret) {

I do think theses are a _wee_ bit _too_ broken out.  In this case, it's
highly beneficial to just be able to look in the same email to make sure
that, "yeah, zone_end_pfn() is the same as the code that it replaces".
The fact that it was defined 15 patches ago makes it a bit harder to
review.  It's much nicer to review if there's _one_ patch that does the
"define this new function and do all of the replacements".

Anyway, the series looks good.  Feel free to add my:

Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>

