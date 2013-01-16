Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab3APBPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:15:41 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35205 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab3APBPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:15:39 -0500
Message-ID: <50F5FD7E.4080901@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 17:08:14 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 01/17] mm/compaction: rename var zone_end_pfn to avoid
 conflicts with new function
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com> <1358295894-24167-2-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1358295894-24167-2-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011601-5406-0000-0000-0000043E08B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 04:24 PM, Cody P Schafer wrote:
> Patches that follow add a inline function zone_end_pfn(), which
> conflicts with the naming of a local variable in isolate_freepages().
> 
> Rename the variable so it does not conflict.

It's probably worth a note here that you _will_ be migrating this use
over to the new function anyway.

> @@ -706,7 +706,7 @@ static void isolate_freepages(struct zone *zone,
>  		 * only scans within a pageblock
>  		 */
>  		end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
> -		end_pfn = min(end_pfn, zone_end_pfn);
> +		end_pfn = min(end_pfn, z_end_pfn);

Is there any reason not to just completely get rid of z_end_pfn (in the
later patches after you introduce zone_end_pfn() of course):

> +		end_pfn = min(end_pfn, zone_end_pfn(zone));

I wouldn't be completely opposed to you just introducing zone_end_pfn()
and doing all the replacements in a single patch.  It would make it
somewhat easier to review, and it would also save the juggling you have
to do with this one.

