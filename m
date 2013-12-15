Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3LORcE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:32:04 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751798Ab3LORcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:32:02 -0500
From: Richard Weinberger <richard@nod.at>
To: John <da_audiophile@yahoo.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david.heidelberger@ixit.cz" <david.heidelberger@ixit.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
Date: Sun, 15 Dec 2013 18:31:51 +0100
Message-ID: <4564841.2xY9pPqtcq@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1387111370.81380.YahooMailNeo@web140001.mail.bf1.yahoo.com>
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com> <CAFLxGvxakZS5FFQcZ_ogTd9aUENT3ECj2Lxs+FCbZAiGqgOJ7g@mail.gmail.com> <1387111370.81380.YahooMailNeo@web140001.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 15. Dezember 2013, 04:42:50 schrieb John:
> ----- Original Message -----
> 
> > From: Richard Weinberger <>
> > 
> > A *very* small speedup.
> > 
> > And I really doubt your numbers.
> > Why are you using ANOVA? You're comparing *two* groups not more than two.
> > I had a quick look at your raw numbers, they don't seem to be normally
> > distributed at all.
> > Did you remove some peaks?
> 
> Hi Richard.  Thank you for your interest.  Yes, a small speedup as I
> mentioned but  I'll note that the current kernel code includes the MCORE2
> option.  I tested this against some of the newer ones and they are all on
> par with each other.  For example, here are differences in median values:
> 
> CPUDifference in median value
> core2        +87.5 ms
> core7-avx+79.7 ms
> core-avx-i+257.2 ms
> 
> I am using ANOVA to establish that the generic group differs from the
> optimized group.  I have always used ANOVA for this sort of comparison
> whether using two or more groups.  In fact, thumb through any medical or
> scientific journal, you'll see others in pier reviewed article doing the
> same.  

Only because others so does not make it valid.
Why not a plain T-test?

> I did not remove any datapoints; I do not understand why you don't think the
> sets are normally distributed.  Did you see the normal quantile plots?
>  Additionally, the population variances are fairly equal (Levene and
> Barlett tests). 

Just perform a simple Kolmogorow-Smirnow test like on 
http://jumk.de/statistic-calculator or http://www.physics.csbsju.edu/stats/KS-test.n.plot_form.html and you'll find out.
IIRC from my statistics 101 you'd have to perform a two-sided ANOVA test
if your data points are not normally distributed.

That said, we should not waste time with statistics games.
What we need are reliable and reproducible results.
As Boris requested many times before...

Thanks,
//richard
