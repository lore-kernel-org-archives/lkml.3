Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaJMKnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:43:52 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:41999 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaJMKnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <53DBCBE8.6010809@codeaurora.org>
References: <1406634362-811-1-git-send-email-prarit@redhat.com>
	<2066166.pXm4lKLOID@vostro.rjw.lan>
	<53DA8389.80804@redhat.com>
	<1917362.abr2Y4p7vh@vostro.rjw.lan>
	<53DA8A41.2030601@redhat.com>
	<53DAA60B.6040802@codeaurora.org>
	<53DAA749.5080506@redhat.com>
	<53DAA95B.2040505@codeaurora.org>
	<53DAB038.3050007@redhat.com>
	<53DABFA6.6090503@codeaurora.org>
	<53DACA26.1000908@redhat.com>
	<53DAE592.2030909@codeaurora.org>
	<53DB6B81.6050400@redhat.com>
	<53DBCBE8.6010809@codeaurora.org>
Date: Mon, 13 Oct 2014 16:13:50 +0530
Message-ID: <CAKohpomk0GNJcGKxLX3HuaMBgPiSNzFp5BniyNgRbtoLqPm6bQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem to
 be held for duration of changing governors [v2]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 August 2014 22:48, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 08/01/14 03:27, Prarit Bhargava wrote:
>>
>> Can you send me the test and the trace of the deadlock?  I'm not creating it with:
>>
>
> This was with conservative as the default, and switching to ondemand
>
> # cd /sys/devices/system/cpu/cpu2/cpufreq
> # ls
> affected_cpus                  scaling_available_governors
> conservative                   scaling_cur_freq
> cpuinfo_cur_freq               scaling_driver
> cpuinfo_max_freq               scaling_governor
> cpuinfo_min_freq               scaling_max_freq
> cpuinfo_transition_latency     scaling_min_freq
> related_cpus                   scaling_setspeed
> scaling_available_frequencies  stats
> # cat conservative/down_threshold
> 20
> # echo ondemand > scaling_governor
>
>  ======================================================
>  [ INFO: possible circular locking dependency detected ]
>  3.16.0-rc3-00039-ge1e38f124d87 #47 Not tainted
>  -------------------------------------------------------
>  sh/75 is trying to acquire lock:
>   (s_active#9){++++..}, at: [<c0358a94>] kernfs_remove_by_name_ns+0x3c/0x84

Can you please retry this on mainline? I wasn't able to reproduce it
now over 3.17.
I am trying this on Exynos b.L implementation..
