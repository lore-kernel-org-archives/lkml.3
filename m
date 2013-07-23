Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab3GWQUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:20:24 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63945 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab3GWQUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:20:21 -0400
MIME-Version: 1.0
In-Reply-To: <CADZ9YHgdK86MuGk7QcsYt+pRZpJ7GYG-rUWf77p9jWZvkw+i5w@mail.gmail.com>
References: <1374594257.5382.5.camel@localhost.localdomain>
	<20130723154736.GB27075@twins.programming.kicks-ass.net>
	<CADZ9YHgdK86MuGk7QcsYt+pRZpJ7GYG-rUWf77p9jWZvkw+i5w@mail.gmail.com>
Date: Tue, 23 Jul 2013 22:20:20 +0600
Message-ID: <CADZ9YHj9vQU7Ki2+mCH5TPGUrn_d3V5bks9dumyEGcMwX3XApA@mail.gmail.com>
Subject: Re: [PATCH, RFC] sched: update_top_cache_domain only at the times of
 building sched domain.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:09 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Tue, Jul 23, 2013 at 9:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, Jul 23, 2013 at 09:44:17PM +0600, Rakib Mullick wrote:
>>>  Currently, update_top_cache_domain() is called whenever schedule domain is built or destroyed. But, the following
>>> callpath shows that they're at the same callpath and can be avoided update_top_cache_domain() while destroying schedule
>>> domain and update only at the times of building schedule domains.
>>>
>>>       partition_sched_domains()
>>>               detach_destroy_domain()
>>>                       cpu_attach_domain()
>>>                               update_top_cache_domain()
>>>               build_sched_domains()
>>>                       cpu_attach_domain()
>>>                               update_top_cache_domain()
>>>
>>
>> Does it really matter?
>
> Why should we do it twice? More importantly at the time of destroying
> even though we know it'll be built again just few moment later.
>
>>
>>
>> This just makes the code uglier for no gain afaict.
>>
>> If you really need to do this, key off @sd == NULL or something.
>
> Sorry, would you please a bit more clearer? I can't pick what you're suggesting.

You mean using sd == NULL rather than using update_cache_domain variable ?
