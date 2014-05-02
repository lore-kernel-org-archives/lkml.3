Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaEBPPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:15:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58587 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752704AbaEBPPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:15:53 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: peterz@infradead.org, mingo@elte.hu, amit.kucheria@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] sched: idle: Encapsulate the code to compile it out
Date: Fri, 02 May 2014 17:32:25 +0200
Message-ID: <8539453.ED7vQGf2Gc@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53639F1B.5080000@linaro.org>
References: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org> <2782801.UzoMhgfu56@vostro.rjw.lan> <53639F1B.5080000@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2014 03:35:23 PM Daniel Lezcano wrote:
> On 05/02/2014 02:09 PM, Rafael J. Wysocki wrote:
> > On Friday, May 02, 2014 10:52:27 AM Daniel Lezcano wrote:
> >> On 05/01/2014 12:47 AM, Rafael J. Wysocki wrote:
> >>> On Wednesday, April 30, 2014 02:01:02 PM Daniel Lezcano wrote:
> >>>> Encapsulate the large portion of cpuidle_idle_call inside another
> >>>> function so when CONFIG_CPU_IDLE=n, the code will be compiled out.
> >>>> Also that is benefitial for the clarity of the code as it removes
> >>>> a nested indentation level.
> >>>>
> >>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >>>
> >>> Well, this conflicts with
> >>>
> >>> https://patchwork.kernel.org/patch/4071541/
> >>>
> >>> which you haven't commented on and I still want cpuidle_select() to be able to
> >>> return negative values because of
> >>>
> >>> https://patchwork.kernel.org/patch/4089631/
> >>>
> >>> (and I have one more patch on top of these two that requires this).
> >>>
> >>> Any ideas how to resolve that?
> >>
> >> I don't think we have a big conflict. If Peter takes your patches before
> >> than mines then I will refresh and resend them.
> >
> > Actually, I was planning the merge them myself, because they are more cpuidle
> > than the scheduler, but either way would be fine.
> 
> Well I have some patches for the scheduler which will need these 
> modifications. Is it possible to merge them throw a common branch to be 
> shared between sched and pm ?

That would be perfectly fine by me, but I'm not sure what Ingo and Peter think
about that.

I can set up a branch with sched/idle/cpuidle changes.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
