Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763377Ab3ECTS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:18:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57048 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763031Ab3ECTS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:18:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH, RFC 02/22] cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
Date: Fri, 03 May 2013 21:27:12 +0200
Message-ID: <5824559.D65khaWcvS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpon9qmowJ4PmL-nvnoaCzJSC-ZSPv8EUOyoFcTdRqNRwnw@mail.gmail.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <5563691.6kxbXZTjH5@vostro.rjw.lan> <CAKohpon9qmowJ4PmL-nvnoaCzJSC-ZSPv8EUOyoFcTdRqNRwnw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 03, 2013 06:31:52 PM Viresh Kumar wrote:
> On 3 May 2013 17:45, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > In this particular case I think it is OK to make both ARM_DT_BL_CPUFREQ and
> > ARM_BIG_LITTLE_CPUFREQ depend on ARM_CPU_TOPOLOGY, because (in theory?) the
> > latter may be set without the former (unless you want to make ARM_DT_BL_CPUFREQ
> > depend on ARM_BIG_LITTLE_CPUFREQ, but then it may be kind of confusing to
> > users).
> 
> ARM_BIG_LITTLE_CPUFREQ is the core cpufreq code for big LITTLE SoC's and every
> other driver will be a glue providing ops to it. So, ARM_DT_BL_CPUFREQ
> does depend
> on ARM_BIG_LITTLE_CPUFREQ and that's why i added depends on
> ARM_CPU_TOPOLOGY in ARM_BIG_LITTLE_CPUFREQ only and depends on
> ARM_BIG_LITTLE_CPUFREQ in ARM_DT_BL_CPUFREQ.

I'm seeing "select" in there, which is kind of different from "depends on".

> But the problem is if ARM_DT_BL_CPUFREQ isn't selected then we still get
> ARM_DT_BL_CPUFREQ enabled in menuconfig but a warning just before compilation.
> Which Arnd pointed to..

What do you mean by "enabled in menuconfig"?  Does it appear as an option to
select or is it actually selected?

In any case, I'm afraid adding ARM_CPU_TOPOLOGY to the "depends on" list in
ARM_DT_BL_CPUFREQ is the only way to avoid that particular warning.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
