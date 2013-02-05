Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3BEBBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:01:03 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41088 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3BEBBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:01:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nathan Zimmer <nzimmer@sgi.com>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
Date: Tue, 05 Feb 2013 02:07:18 +0100
Message-ID: <2765418.Ft0GYkgNgL@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 04, 2013 04:45:11 PM Nathan Zimmer wrote:
> I am noticing the cpufreq_driver_lock is quite hot.
> On an idle 512 system perf shows me most of the system time is spent on this
> lock.  This is quite signifigant as top shows 5% of time in system time.
> My solution was to first convert the lock to a rwlock and then to the rcu.
> 
> 
> Nathan Zimmer (2):
>   cpufreq: Convert the cpufreq_driver_lock to a rwlock
>   cpufreq: Convert the cpufreq_driver_lock to use the rcu
> 
>  drivers/cpufreq/cpufreq.c | 139 ++++++++++++++++++++++++++--------------------
>  1 file changed, 79 insertions(+), 60 deletions(-)

I like these changes.

Viresh, anyone, any comments?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
