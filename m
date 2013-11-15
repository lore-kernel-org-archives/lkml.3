Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3KOTdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:33:43 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:33107 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3KOTdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:33:38 -0500
MIME-Version: 1.0
In-Reply-To: <52861DCB.9020206@linux.com>
References: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>
	<20131113000358.GA2420@gmail.com>
	<CAMP44s17p0ZpFx0Y2E_K7Oq9c4tk2J+9uXRWDYChAD-yM-4JjQ@mail.gmail.com>
	<52850B89.10605@linux.com>
	<52853fe6b0fd9_bf6d31e7c1a@nysa.notmuch>
	<CAMP44s0kGhPvuVZMe4zpmqFLtxrLW2gBPu6eHg0G6DFYKNpW7Q@mail.gmail.com>
	<52861DCB.9020206@linux.com>
Date: Fri, 15 Nov 2013 13:33:36 -0600
Message-ID: <CAMP44s0q06Qe9BTHTaamFNkic+8_ecATXVACRVNqpRDqw6r5Qg@mail.gmail.com>
Subject: Re: [PATCH v2] panic: setup panic_timeout early
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 7:12 AM, Levente Kurusa <levex@linux.com> wrote:

> No, you don't want timeout to be a long, and instead of kstrtol, you should use
> kstrtoint(char *s, int base, int *res)
> which is defined in lib/ktstrtox.c

And if you look into kstrtoint() you would see that it's doing
*exactly* the same I'm doing; using a temporary bigger integer, same
as STANDARD_PARAM_DEF.

> Also, a bit of advice: Calm down. If you continue to act childish nobody will take
> you seriously. Before acting like you are the king here, please at least take the time
> to research other options.

I am irrelevant, the code is what matters, and panic_timeout should be
set early on, regardless of who is sending the patch.

Moreover, if you are going to claim that I didn't research other
options, then the guy that did this:

  STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);

Didn't research other options either, because it should be:

  STANDARD_PARAM_DEF(int, int, "%i", int, kstrtoint);

Presumably it doesn't matter much, but it seems it does matter when
*I* am the one sending the patch.

And what exactly is childish about asking this question?

> So you would rather have this?
>
>   kstrtol(val, 0, (long *)&timeout);

The answer should be: no, use kstrtoint(), but that wasn't your
answer, was it? Your answer basically repeated what Ingo said, so I
had to go step by step to the conclusion of 'kstrtol(val, 0, (long
*)&timeout);'. And then I asked you a question: "What else do you
suggest to fix the problem that kstrtol() expects a long?" *Now* your
answer is useful. Why is that childish?

Now, in this process a few things are clear to me:

1) loglevel should use kstrtoint() as well, not get_option
2) get_option() should use kstrtoint(); it's using simple_strtol() and
it's not even checking for overflows
3) It should be STANDARD_PARAM_DEF(int, int, "%i", int, kstrtoint);

Don't you think it's little bit of a stretch to say that *I* didn't do
my research, when in fact I did, and none of the parameters code is
using kstrtoint() as it should, even Ingo himself told me I should use
simple_strtol(), which is actually deprecated.

My patch is simply doing what similar code is already doing. Why don't
you take a step back and accept the possibility that a) I did do my
research, and b) I wasn't being childish in asking how to make kstrtol
work (given that Ingo suggested to use simple_strtol()). I think you
should take your own advice and calm down, maybe even take back what
you said. Maybe I was combative, and maybe I made the wrong
assumptions, but at least I didn't throw insults, nor called anybody
names like "childish".

Anyway, I will update the patch to sue kstrtoint(), and I would gladly
fix the existing code for issues 1) 2) and 3) *if* you or anybody
agrees they should be using kstrtoint() as well, I'm not in the mood
of going through Ingo's review process again for something so trivial.

Cheers.

-- 
Felipe Contreras
