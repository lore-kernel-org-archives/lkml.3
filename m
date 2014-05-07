Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaEGFXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:23:20 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41669 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaEGFXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <5369220A.3030207@semaphore.gr>
References: <535AC247.3070907@semaphore.gr>
	<CAKohpok-74uK5k-adxjmEy71=vF8V7MaBwdCD1Vb2ats7FHi_A@mail.gmail.com>
	<535FCDBD.6080500@semaphore.gr>
	<1621123.rMC9JtD3Mo@vostro.rjw.lan>
	<CAMuHMdU6eKQbmqvDj8Ra3MjuqhvFQ6WxoTsiJ4mojqXY4XOtaw@mail.gmail.com>
	<5369220A.3030207@semaphore.gr>
Date: Wed, 7 May 2014 10:53:16 +0530
Message-ID: <CAKohpo=3_7G+3bMF2CpWgZXvktdXBkCi4-tCxogwGcvvEEh18w@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] Introduce new cpufreq helper macros
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2014 23:25, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> My bad. I'm sorry for this. :(
>
> Rafael,
> A solution could be to make cpufreq_next_valid an inline function in cpufreq.h,
> but as Viresh mentioned this would be very inefficient because of multiple copies.

That statement was true when we didn't had this problem..

> So, maybe it's better to revert the 2 patches that don't depend on CONFIG_CPU_FREQ:
>
> 4229e1c61a4a ("sh: clk: Use cpufreq_for_each_valid_entry macro for iteration") and
> 04ae58645afa ("irda: sh_sir: Use cpufreq_for_each_valid_entry macro for iteration").

This doesn't look right. It can happen to some other drivers as well in future.
So, there are two solutions I can think of:
1. move cpufreq_next_valid and rename it to __cpufreq_next_valid(). Also make it
inline. Then create two versions of cpufreq_next_valid(), one inlined (only when
CONFIG_CPU_FREQ=n) and other one in cpufreq.c (non- inlined)..

But probably that would be called ugly by some people :)

2. Make cpufreq_next_valid() inline and forget about extra space it takes :)

@Rafel: Let me know which one you like :)
