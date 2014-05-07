Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaEGWUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:20:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62352 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750966AbaEGWUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:20:48 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>, Sekhar Nori <nsekhar@ti.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH v5 0/8] Introduce new cpufreq helper macros
Date: Thu, 08 May 2014 00:37:27 +0200
Message-ID: <1628906.bvqGfBpWxn@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <536A3654.20201@semaphore.gr>
References: <535AC247.3070907@semaphore.gr> <4469396.zveA7sC36d@vostro.rjw.lan> <536A3654.20201@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 07, 2014 04:34:12 PM Stratos Karafotis wrote:
> Hi Rafael,
> 
> On 07/05/2014 04:13 μμ, Rafael J. Wysocki wrote:
> > On Wednesday, May 07, 2014 10:53:16 AM Viresh Kumar wrote:
> >> On 6 May 2014 23:25, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> >>> My bad. I'm sorry for this. :(
> >>>
> >>> Rafael,
> >>> A solution could be to make cpufreq_next_valid an inline function in cpufreq.h,
> >>> but as Viresh mentioned this would be very inefficient because of multiple copies.
> >>
> >> That statement was true when we didn't had this problem..
> >>
> >>> So, maybe it's better to revert the 2 patches that don't depend on CONFIG_CPU_FREQ:
> >>>
> >>> 4229e1c61a4a ("sh: clk: Use cpufreq_for_each_valid_entry macro for iteration") and
> >>> 04ae58645afa ("irda: sh_sir: Use cpufreq_for_each_valid_entry macro for iteration").
> >>
> >> This doesn't look right. It can happen to some other drivers as well in future.
> >> So, there are two solutions I can think of:
> >> 1. move cpufreq_next_valid and rename it to __cpufreq_next_valid(). Also make it
> >> inline. Then create two versions of cpufreq_next_valid(), one inlined (only when
> >> CONFIG_CPU_FREQ=n) and other one in cpufreq.c (non- inlined)..
> >>
> >> But probably that would be called ugly by some people :)
> >>
> >> 2. Make cpufreq_next_valid() inline and forget about extra space it takes :)
> >>
> >> @Rafel: Let me know which one you like :)
> > 
> > 2.
> > 
> > 
> 
> Do you want me to resend the entire patch set or only patch 1/8?

It's already on a branch that cannot be rebased.  Please send me a fix on top of it.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
