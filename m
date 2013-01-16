Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3APBTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:19:19 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56854 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057Ab3APBTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:19:17 -0500
Message-ID: <50F6000A.3010601@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 17:19:06 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>
Subject: Re: [PATCH 02/17] mmzone: add various zone_*() helper functions.
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com> <1358295894-24167-3-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1358295894-24167-3-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011601-9360-0000-0000-00000F400938
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 04:24 PM, Cody P Schafer wrote:
> +static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
> +{
> +	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
> +}

This needs some parenthesis, just for readability.  There's also no
crime in breaking it up to be multi-line if you want.

> +static inline bool zone_is_initialized(struct zone *zone)
> +{
> +	return !!zone->wait_table;
> +}
> +
> +static inline bool zone_is_empty(struct zone *zone)
> +{
> +	return zone->spanned_pages == 0;
> +}



