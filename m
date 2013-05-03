Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198Ab3ECNBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:01:55 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:59331 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761934Ab3ECNBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:01:53 -0400
MIME-Version: 1.0
In-Reply-To: <5563691.6kxbXZTjH5@vostro.rjw.lan>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
	<1367507786-505303-3-git-send-email-arnd@arndb.de>
	<CAKohpomBKuaxk+sSF63cu6JKut1uV7J7Sj2o85c3wQ=fodx+Ow@mail.gmail.com>
	<5563691.6kxbXZTjH5@vostro.rjw.lan>
Date: Fri, 3 May 2013 18:31:52 +0530
Message-ID: <CAKohpon9qmowJ4PmL-nvnoaCzJSC-ZSPv8EUOyoFcTdRqNRwnw@mail.gmail.com>
Subject: Re: [PATCH, RFC 02/22] cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2013 17:45, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> In this particular case I think it is OK to make both ARM_DT_BL_CPUFREQ and
> ARM_BIG_LITTLE_CPUFREQ depend on ARM_CPU_TOPOLOGY, because (in theory?) the
> latter may be set without the former (unless you want to make ARM_DT_BL_CPUFREQ
> depend on ARM_BIG_LITTLE_CPUFREQ, but then it may be kind of confusing to
> users).

ARM_BIG_LITTLE_CPUFREQ is the core cpufreq code for big LITTLE SoC's and every
other driver will be a glue providing ops to it. So, ARM_DT_BL_CPUFREQ
does depend
on ARM_BIG_LITTLE_CPUFREQ and that's why i added depends on
ARM_CPU_TOPOLOGY in ARM_BIG_LITTLE_CPUFREQ only and depends on
ARM_BIG_LITTLE_CPUFREQ in ARM_DT_BL_CPUFREQ.

But the problem is if ARM_DT_BL_CPUFREQ isn't selected then we still get
ARM_DT_BL_CPUFREQ enabled in menuconfig but a warning just before compilation.
Which Arnd pointed to..
