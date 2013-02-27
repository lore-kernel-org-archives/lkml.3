Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab3B0PwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:52:14 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57538 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760052Ab3B0PwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:52:12 -0500
Message-ID: <512E2B91.6000506@linux.vnet.ibm.com>
Date: Wed, 27 Feb 2013 07:51:45 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, show_mem: suppress page counts in non-blockable contexts
References: <alpine.DEB.2.02.1302261642520.11109@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1302261642520.11109@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022715-5806-0000-0000-0000201F518E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 04:46 PM, David Rientjes wrote:
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -99,6 +99,9 @@ void show_mem(unsigned int filter)
>  	printk("Mem-info:\n");
>  	show_free_areas(filter);
> 
> +	if (filter & SHOW_MEM_FILTER_PAGE_COUNT)
> +		return;
> +

Won't this just look like a funky truncated warning to the end user?

Seems like we should at least dump out a little message for this stuff
to say that it's intentionally truncated?

