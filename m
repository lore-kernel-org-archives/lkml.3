Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaE0Pml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:42:41 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63430 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaE0Pmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:42:40 -0400
Message-ID: <5384B26D.1000703@kernel.dk>
Date: Tue, 27 May 2014 09:42:37 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-27 09:23, Mikulas Patocka wrote:
>
>
> On Tue, 27 May 2014, Jens Axboe wrote:
>
>> On 2014-05-27 09:03, Mikulas Patocka wrote:
>>> The block layer uses per-process bio list to avoid recursion in
>>> generic_make_request. When generic_make_request is called recursively, the
>>> bio is added to current->bio_list and the function returns immediatelly.
>>> The top-level instance of generic_make_requests takes bios from
>>> current->bio_list and processes them.
>>
>> This really begs the question of why we just don't use the per-process plugs
>> for this. We already have scheduler hooks in place to flush those at the
>> appropriate time. Why are we reinventing something for essentially the same
>> thing?
>>
>> --
>> Jens Axboe
>
> Plugs work with requests, this patch works with bios. They are different
> structures, so you can't use one infrastructure to process them.

Yes... I realize the list and plugs are for requests. But there's 
nothing preventing a non-rq hook, we have uses like that too. And it 
could easily be extended to handle bio lists, too.

> The patch adds bio list flushing to the scheduler just besides plug
> flushsing.

... which is exactly why I'm commenting. It'd be great to avoid yet one 
more scheduler hook for this sort of thing.

-- 
Jens Axboe

