Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbaGYR6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:58:10 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54042 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaGYR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:58:08 -0400
MIME-Version: 1.0
In-Reply-To: <53D28457.202@redhat.com>
References: <20140722144559.382c5243@annuminas.surriel.com>
 <20140725152728.GB6758@twins.programming.kicks-ass.net> <53D27B7E.8090404@redhat.com>
 <20140725160549.GD6758@twins.programming.kicks-ass.net> <53D28457.202@redhat.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 25 Jul 2014 19:57:47 +0200
Message-ID: <CAKfTPtBVTgTYmgRKbuhKNZZRuCRK126YVvsG1+a-hjfKao08=g@mail.gmail.com>
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a
 busier sd
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2014 18:22, Rik van Riel <riel@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 07/25/2014 12:05 PM, Peter Zijlstra wrote:
>> On Fri, Jul 25, 2014 at 11:45:02AM -0400, Rik van Riel wrote:
>>>> So for !ASYM the code is effectively:
>>>>
>>>> return sgs->avg_load > sds->busiest_stat.avg_load;
>>>>
>>>> I'd like to at least add a clause that makes overloaded groups
>>>>  prioritized over !overloaded groups.
>>>>
>>>> Also, like we found earlier, calculate_imbalance() relies on
>>>> the sum_nr_running > group_capacity_factor thing, which you've
>>>> just 'wrecked', so we'd need an update to that part too.
>>>
>>> I guess that would mean update_sd_pick_busiest would look like
>>> this for the !ASYM case:
>>>
>>> 1) remembering whether busiest is overloaded
>>>
>>> 2) if (sgs->busiest_stat.overloaded && !sgs->overloaded) return
>>> false;
>>>
>>> 3) if (sgs->avg_load > sds->busiest_stat.avg_load) return true;
>>
>> Right. So the situation I was worried about is where we have say 8
>> +nice tasks in one group and 2 -nice in another. So the group with
>> 2 tasks can actually be 'heavier' but not fully utilized. In that
>> case we want to pull tasks from the lighter but overloaded group.
>
> I can certainly create a new patch that makes update_sd_pick_busiest
> do just that.
>
> Vincent, any objections to me fixing update_sd_pick_busiest now, or
> will that conflict with your code cleanups?

It will probably conflict with my patchset which also modify
update_sd_pick_busiest but we should be able to manage the conflict.
So feel free to send a patch that fix the description above and we
will see how to handle the conflict when it will occur

Vincent

>
> - --
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>
> iQEcBAEBAgAGBQJT0oRWAAoJEM553pKExN6DRdoH/2VsMEbeRdr9o99CYV3hK2bj
> OT4O5xlz47aBq+/J3Sp35DZKtQ8PpYICNoNzddyF5Blr7ZcXB2OQj5Cv5Lj3Dtcs
> q/AnJAN+6mDNq4B3aVfTb3BMDcrSz8LNdpNwVM80gfvbcZkcWIYWF2FigShIggMZ
> bKz4cC5hVphtYR/WH6gnb5dXwgXBGYatwYsDXnVw6SLRbXcwYrB646SmZYXDVcER
> bOj5IAjdfAlFkLbeow6OaX1arBrd6lyKfVI4Mzr848dqLBrJvmPvx/R4Z8EzPN2H
> Gv4kqU7s9CAk1QOZLHWAOCDjG7PdMZfkS7WEZnQinMIutBK/jYJ4IXY8NNeS96I=
> =OcR0
> -----END PGP SIGNATURE-----
