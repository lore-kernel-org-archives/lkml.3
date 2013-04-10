Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936518Ab3DJUpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:45:08 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58746 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762080Ab3DJUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:45:06 -0400
Message-ID: <5165CEB0.3010504@linux.vnet.ibm.com>
Date: Thu, 11 Apr 2013 02:12:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Simplify for_each_populated_zone()
References: <20130410202727.20368.29222.stgit@srivatsabhat.in.ibm.com> <alpine.DEB.2.02.1304101339260.25932@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1304101339260.25932@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041020-5816-0000-0000-000007801F7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 02:11 AM, David Rientjes wrote:
> On Thu, 11 Apr 2013, Srivatsa S. Bhat wrote:
> 
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index ede2749..2489042 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -948,9 +948,7 @@ extern struct zone *next_zone(struct zone *zone);
>>  	for (zone = (first_online_pgdat())->node_zones; \
>>  	     zone;					\
>>  	     zone = next_zone(zone))			\
>> -		if (!populated_zone(zone))		\
>> -			; /* do nothing */		\
>> -		else
>> +		if (populated_zone(zone))
>>  
>>  static inline struct zone *zonelist_zone(struct zoneref *zoneref)
>>  {
> 
> Nack, it's written the way it is to avoid ambiguous else statements 
> following it.  People do things like
> 
> 	for_each_populated_zone(z)
> 		if (...) {
> 		} else (...) {
> 		}
> 
> and it's now ambiguous (and should warn with -Wparentheses).
> 

Hmm, fair enough. Please ignore this patch then. Thanks!

Regards,
Srivatsa S. Bhat

