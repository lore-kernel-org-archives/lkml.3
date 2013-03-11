Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3CKXQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:16:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52869 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3CKXQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:16:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: viresh.kumar@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
Date: Tue, 12 Mar 2013 00:23:08 +0100
Message-ID: <3505617.pgqBjPDzlA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1361550275-5716-1-git-send-email-nzimmer@sgi.com>
References: <51265E0F.6090209@sgi.com> <1361550275-5716-1-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 10:24:33 AM Nathan Zimmer wrote:
> I am noticing the cpufreq_driver_lock is quite hot.
> On an idle 512 system perf shows me most of the system time is spent on this
> lock.  This is quite significant as top shows 5% of time in system time.
> My solution was to first convert the lock to a rwlock and then to the rcu.
> 
> v2: Rebase
> 
> v3: Read the RCU documentation instead of skimming it.  Also I based on 
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.9-rc1
> I assumed that was what you would prefer Rafael.
> 
> v4: Removed an unnecessary syncronize_rcu().
> 
> 
> Nathan Zimmer (2):
>   cpufreq: Convert the cpufreq_driver_lock to a rwlock
>   cpufreq: Convert the cpufreq_driver_lock to use the rcu
> 
>  drivers/cpufreq/cpufreq.c | 286 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 211 insertions(+), 75 deletions(-)

I'm going to take patch [1/2] for v3.10, but patch [2/2] still needs some
work it seems.  Is that correct?  If so, are you going to send an update?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
