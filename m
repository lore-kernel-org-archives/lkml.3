Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaE0Rma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:42:30 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35769 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaE0Rm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:42:28 -0400
Message-ID: <5384CE82.90601@kernel.dk>
Date: Tue, 27 May 2014 11:42:26 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com> <5384B26D.1000703@kernel.dk> <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-27 10:26, Mikulas Patocka wrote:
> On Tue, 27 May 2014, Jens Axboe wrote:
>
>> On 2014-05-27 09:23, Mikulas Patocka wrote:
>>
>>> The patch adds bio list flushing to the scheduler just besides plug
>>> flushsing.
>>
>> ... which is exactly why I'm commenting. It'd be great to avoid yet one more
>> scheduler hook for this sort of thing.
>>
>> --
>> Jens Axboe
>
> One could create something like schedule notifier chain, but I'm not sure
> if it is worth the complexity because of just two users. If more users
> come in the future, it could be generalized.

Except such a thing already exists, there are unplug callback chains. 
All I'm asking is that you look into how feasible it would be to use 
something like that, instead of reinventing the wheel.

-- 
Jens Axboe

