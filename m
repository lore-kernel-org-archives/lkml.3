Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3FSHUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:20:17 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40033 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3FSHUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:20:15 -0400
X-Spam-Score: -100.8
Message-ID: <51C15B7B.9060804@asianux.com>
Date: Wed, 19 Jun 2013 15:19:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, hannes@cmpxchg.org, riel@redhat.com,
        mhocko@suse.cz, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/vmscan.c: 'lru' may be used without initialized after
 the patch "3abf380..." in next-20130607 tree
References: <51C155D1.3090304@asianux.com> <20130619001029.ee623fae.akpm@linux-foundation.org>
In-Reply-To: <20130619001029.ee623fae.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 03:10 PM, Andrew Morton wrote:
> On Wed, 19 Jun 2013 14:55:13 +0800 Chen Gang <gang.chen@asianux.com> wrote:
> 
>> > 
>> > 'lru' may be used without initialized, so need regressing part of the
>> > related patch.
>> > 
>> > The related patch:
>> >   "3abf380 mm: remove lru parameter from __lru_cache_add and lru_cache_add_lru"
>> >
>> > ...
>> >
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -595,6 +595,7 @@ redo:
>> >  		 * unevictable page on [in]active list.
>> >  		 * We know how to handle that.
>> >  		 */
>> > +		lru = !!TestClearPageActive(page) + page_lru_base_type(page);
>> >  		lru_cache_add(page);
>> >  	} else {
>> >  		/*
> That looks right.  Why the heck didn't gcc-4.4.4 (at least) warn about it?
> 

Sorry I don't know either, I find it by reading code, this time.

It is really necessary to continue analyzing why. In 2nd half of 2013, I
have planned to make some patches outside kernel but related with kernel
(e.g. LTP, gcc patches).

This kind of issue is a good chance for me to start in 2nd half of 2013
(start from next month).

So if no others reply for it, I will start analyzing it in the next
month, and plan to finish within a month (before 2013-07-31).


Welcome additional suggestions or completions.

Thanks.
-- 
Chen Gang

Asianux Corporation
