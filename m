Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaJUNK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:10:29 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52530 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932402AbaJUNK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:10:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy
Date: Tue, 21 Oct 2014 15:30:52 +0200
Message-ID: <25726997.FVACNx9Uy9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <543FDEC8.1080102@gmail.com>
References: <1413415011-31290-1-git-send-email-pali.rohar@gmail.com> <543FDEC8.1080102@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 16, 2014 08:05:44 AM Dirk Brandewie wrote:
> On 10/15/2014 04:16 PM, Pali Rohár wrote:
> > Code which changes policy to powersave changes also max_policy_pct based on
> > max_freq. Code which change max_perf_pct has upper limit base on value
> > max_policy_pct. When policy is changing from powersave back to performance
> > then max_policy_pct is not changed. Which means that changing max_perf_pct is
> > not possible to high values if max_freq was too low in powersave policy.
> >
> > Test case:
> >
> > $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
> > 800000
> > $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> > 3300000
> > $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> > performance
> > $ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
> > 100
> >
> > $ echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> > $ echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> > $ echo 20 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
> >
> > $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> > powersave
> > $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> > 800000
> > $ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
> > 20
> >
> > $ echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> > $ echo 3300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> > $ echo 100 > /sys/devices/system/cpu/intel_pstate/max_perf_pct
> >
> > $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> > performance
> > $ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
> > 3300000
> > $ cat /sys/devices/system/cpu/intel_pstate/max_perf_pct
> > 24
> >
> > And now intel_pstate driver allows to set maximal value for max_perf_pct based
> > on max_policy_pct which is 24 for previous powersave max_freq 800000.
> >
> > This patch will set default value for max_policy_pct when setting policy to
> > performance so it will allow to set also max value for max_perf_pct.
> >
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> 
> Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Applied, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
