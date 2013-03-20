Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3CTNmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:42:55 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37842 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3CTNmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:42:54 -0400
MIME-Version: 1.0
In-Reply-To: <1363777891.2612.7.camel@laptop>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1360820921-2513-5-git-send-email-iamjoonsoo.kim@lge.com>
	<1363703415.22553.54.camel@laptop>
	<20130320073355.GC11672@lge.com>
	<1363777891.2612.7.camel@laptop>
Date: Wed, 20 Mar 2013 22:42:52 +0900
Message-ID: <CAAmzW4OKTxSCFFCOA=YKSwV_qQjxMb6z6ThELp=w9J2bBG4ObQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] sched: clean up move_task() and move_one_task()
From: JoonSoo Kim <js1304@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/20 Peter Zijlstra <peterz@infradead.org>:
> On Wed, 2013-03-20 at 16:33 +0900, Joonsoo Kim wrote:
>
>> > Right, so I'm not so taken with this one. The whole load stuff really
>> > is a balance heuristic that's part of move_tasks(), move_one_task()
>> > really doesn't care about that.
>> >
>> > So why did you include it? Purely so you didn't have to re-order the
>> > tests? I don't see any reason not to flip a tests around.
>>
>> I think that I'm not fully understand what you are concerning, because of
>> my poor English. If possible, please elaborate on a problem in more detail.
>
> OK, so your initial Changelog said it wanted to remove some code
> duplication between move_tasks() and move_one_task(); but then you put
> in the load heuristics and add a boolean argument to only enable those
> for move_tasks() -- so clearly that wasn't duplicated.
>
> So why move that code.. I proposed that this was due a reluctance to
> re-arrange the various tests that stop the migration from happening.
>
> Now you say:
>
>> ... Just moving up can_migrate_task() above
>> load evaluation code may raise side effect, because can_migrate_task() have
>> other checking which is 'cache hottness'. I don't want a side effect. So
>> embedding load evaluation to can_migrate_task() and re-order checking and
>> makes load evaluation disabled for move_one_task().
>
> Which pretty much affirms this. However I also said that I don't think
> the order really matters that much; each test will cancel the migration
> of this task; the order of these tests seem immaterial.
>
>> If your recommandation is to move up can_mirate_task() above
>> load evaluation code, yes, I can, and will do that. :)
>
> I would actually propose moving the throttled test into
> can_migrate_task() and leave it at that.

Okay. I will do that in next spin.

Thanks!!

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
