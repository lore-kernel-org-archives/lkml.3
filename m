Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab3BTVBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:01:22 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49838 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935243Ab3BTVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:01:21 -0500
MIME-Version: 1.0
In-Reply-To: <m2ppzuyaao.fsf@firstfloor.org>
References: <1361392794-16552-1-git-send-email-jolsa@redhat.com>
	<m2ppzuyaao.fsf@firstfloor.org>
Date: Wed, 20 Feb 2013 22:01:20 +0100
Message-ID: <CABPqkBTCJF9eF_3Nj9nV=PNqVnrcZhkZ90oJfQ6tpHzFDFgptg@mail.gmail.com>
Subject: Re: [PATCH] perf x86: Change SandyBridge and IvyBrige instructions
 event to be precise
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 9:55 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
>
>> Changing the default 'instructions' HW event for SandyBridge and
>> IvyBrige to use the available precise 'instructions' event.
>>
>> The precise event is defined in Intel SDM as:
>>
>> INST_RETIRED.ALL - Precise instruction retired event with HW to
>> reduce effect of PEBS shadow in IP distribution
>>
>> for both SandyBridge and IvyBrige micro-archs. It allows to use
>> precise modifier on 'instructions' event on SandyBridge and
>> IvyBrige micro-archs which is not possible now.
>
There is also the problem that on SNB, PREC_DIST must be
taken ALONE to be correct. By that, I mean no other counter
must be active. So I don't think it is a good idea.

Also PREC_DIST is marked as constrained to counter 2 only.
That in effect, as Andi pointed out, will make the fixed counter
for instruction_retired, unused because you've set a umask now.

I don't think it buys you much. People read too much into what
PEBS gives you. I can show you examples where PEBS
is worse than no PEBS.

> Actually it's possible, you just have to use it explicitely.
>
> This will break a lot of profiling setups that assume instructions
> count on the fixed counter and use the 4/8 other counters.
> Also it will give very bad results with perf stat, which
> you don't want to run with pebs.
>
> Even worse with your change the fixed instruction counter is not
> accessible anymore. So pretty much all the standard setups
> that collect it in addition to other events and fill all
> the counters would break.
>
> I don't think it should be done by default, but yes explicitely
> it's quite useful.
>
> My Haswell patchkit (in the "extended version") exposes
> the precise event as "instructions-p" through sysfs.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
