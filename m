Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaEIACG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 20:02:06 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:56369 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaEIACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 20:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140508205556.GJ3693@n2100.arm.linux.org.uk>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org>
	<CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com>
	<CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>
	<alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>
	<CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com>
	<alpine.LFD.2.11.1405081329010.980@knanqh.ubzr>
	<CAD=FV=X4h0nfO7a10NXe+d76xj5ttBJx=q1pAvW4aPzrc22BoQ@mail.gmail.com>
	<20140508205556.GJ3693@n2100.arm.linux.org.uk>
Date: Thu, 8 May 2014 17:02:02 -0700
X-Google-Sender-Auth: eWpwusT3Q9X2zUxt9KBr6TlnUY0
Message-ID: <CAD=FV=ViOie+E_mxgcE51oNL0HY1zF9KYG_TDSbKjMzE2GZZMw@mail.gmail.com>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russel,

On Thu, May 8, 2014 at 1:55 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, May 08, 2014 at 11:06:24AM -0700, Doug Anderson wrote:
>> I guess I would say that my patch is unhacking the this code.  The
>> code after my patch is simpler.  I would perhaps argue that (ec971ea
>> ARM: add cpufreq transiton notifier to adjust loops_per_jiffy for smp)
>> should never have landed to begin with.
>
> That depends on your point of view.  As I've already pointed out through
> the examples of why udelay() is inaccurate, for driver authors, they
> should assume that udelay() just gives you an "approximate" delay and
> it has no accuracy.

That disagrees with what Thomas Gleixner says at
<http://lkml.iu.edu//hypermail/linux/kernel/1203.1/01034.html>.  It
also seems like perhaps the regulator core is broken, then...  If a
udelay(30) can end up as a udelay(20) then we may return from a
regulator code 10us earlier than we should and we'll assume that a
regulator is ramped before it really is...

I'm out tomorrow but I can confirm on Monday that I was really seeing
udelay(30) be a udelay(20) without this patch.
