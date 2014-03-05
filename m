Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaCEBtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:49:14 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48075 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaCEBtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:49:11 -0500
MIME-Version: 1.0
In-Reply-To: <2332228.mAUBjM5x8d@vostro.rjw.lan>
References: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
	<2332228.mAUBjM5x8d@vostro.rjw.lan>
Date: Wed, 5 Mar 2014 09:49:10 +0800
Message-ID: <CAKohpokRTb=o7xR5y9TLZ8YvSzkMC-37YxuSoUyES-oEOwM-jQ@mail.gmail.com>
Subject: Re: [PATCH V6 Resend 1/5] cpufreq: suspend governors on system suspend/hibernate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        "jinchoi@broadcom.com" <jinchoi@broadcom.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 March 2014 08:37, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> So, previously the driver's ->suspend callback was executed with interrupts off
> and it was only executed for the boot CPU.
>
> Now, it is going to be executed for all CPUs and with interrupts on.

Its not called for all CPUs but once for each instance of 'policy'.

> This sounds potentially dangerous, so did you check all drivers supplying
> ->suspend if they are fine with that?
>
> And same for ->resume, of course.

Completely agree with you on that. I had similar doubts when I started earlier.
And then grep'd for suspend/resume in drivers/cpufreq and this is what I found:

drivers/cpufreq/acpi-cpufreq.c: Only have resume implemented and is unaffected
with new code.

drivers/cpufreq/pmac32-cpufreq.c: This is always UP and so no issues.

drivers/cpufreq/s3c24xx-cpufreq.c: There is only one policy and so would be
called only once.

drivers/cpufreq/speedstep-smi.c: Only has resume implemented and it looks
to be harmless again..

So, I think yes, we shouldn't end up breaking any stuff here. Fingers crossed :)
Otherwise as well, I am not going on leaves or something else in coming weeks
and would be there to fix any issues that might come in. But I am
still hopeful of
not breaking any existing stuff.
