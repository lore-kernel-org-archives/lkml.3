Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935529Ab3DJUl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:41:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59651 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3DJUl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:41:27 -0400
Date: Wed, 10 Apr 2013 13:41:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Simplify for_each_populated_zone()
In-Reply-To: <20130410202727.20368.29222.stgit@srivatsabhat.in.ibm.com>
Message-ID: <alpine.DEB.2.02.1304101339260.25932@chino.kir.corp.google.com>
References: <20130410202727.20368.29222.stgit@srivatsabhat.in.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Srivatsa S. Bhat wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ede2749..2489042 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -948,9 +948,7 @@ extern struct zone *next_zone(struct zone *zone);
>  	for (zone = (first_online_pgdat())->node_zones; \
>  	     zone;					\
>  	     zone = next_zone(zone))			\
> -		if (!populated_zone(zone))		\
> -			; /* do nothing */		\
> -		else
> +		if (populated_zone(zone))
>  
>  static inline struct zone *zonelist_zone(struct zoneref *zoneref)
>  {

Nack, it's written the way it is to avoid ambiguous else statements 
following it.  People do things like

	for_each_populated_zone(z)
		if (...) {
		} else (...) {
		}

and it's now ambiguous (and should warn with -Wparentheses).
