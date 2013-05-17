Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab3EQEnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:43:52 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48497 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3EQEni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:43:38 -0400
MIME-Version: 1.0
In-Reply-To: <4482296.g7Mb85DDVP@vostro.rjw.lan>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
	<6691801.RqjZrI7EgH@vostro.rjw.lan>
	<CAKohpom=_i8MgWy7eoa+wBtaRZ288CMfcYsGBi-4qzu4ZqR3uw@mail.gmail.com>
	<4482296.g7Mb85DDVP@vostro.rjw.lan>
Date: Fri, 17 May 2013 10:13:37 +0530
Message-ID: <CAKohpomOzeHsv=ZDBJGQKAiFWHDczweWF1wZuQDMRZE-0U3=2A@mail.gmail.com>
Subject: Re: [PATCH 0/3] CPUFreq Fixes for 3.10-rc2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2013 02:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> While I kind of understand why you want [3/3] to go into 3.10, I'm wondering
> about the other two patches.  Why exactly are they needed now?

First one:

  cpufreq: Add EXPORT_SYMBOL_GPL for have_governor_per_policy

is required so that governors can be compiled as module. Otherwise they
may break.. I haven't tried that but I believe that is the case.


For second one:

  cpufreq: governors: Move get_governor_parent_kobj() to cpufreq.c

I was actually working on Android's Interactive governor (Where I enabled
same per-policy-instance of governor support), And i required this patch
for its working. Then I thought other platform specific governors present
in mainline might also use this routine and so must be pushed to cpufreq.c.

Now, because this patch is around due to something which got
added in 3.10-rc1, its better to fix it in rcs only rather than fixing
it in 3.11.
I will trust your judgement here, push it for 3.10-rc if it looks okay to you.

> And speaking of patch [3/3], if you paste kernel logs into changelogs, please
> remove the time stamps (unless they are relevant to the problem being fixed).

Okay.. Will keep that in mind.
