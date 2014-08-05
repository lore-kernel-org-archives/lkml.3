Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaHEHqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:46:50 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56124 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaHEHqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:46:49 -0400
MIME-Version: 1.0
In-Reply-To: <53DBEC27.7050803@codeaurora.org>
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
	<53DBE764.8050109@redhat.com>
	<53DBEC27.7050803@codeaurora.org>
Date: Tue, 5 Aug 2014 13:16:48 +0530
Message-ID: <CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com>
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

On 2 August 2014 01:06, Stephen Boyd <sboyd@codeaurora.org> wrote:
> I have the same options. The difference is that my driver has a governor
> per policy. That's set with the CPUFREQ_HAVE_GOVERNOR_PER_POLICY flag.

You may call me stupid but I got a bit confused after looking into the code
again. Why does the crash dump depends on this flag?

We *always* remove the governor specific directory while switching governors
(Ofcourse only if its updated for All CPUs). And so on a dual core platform,
where both CPU 0 & 1 share a clock line, switching of governors should result
in this crash dump?

I may know the answer to the stupid question I had, but not sure why that is a
problem. The only (and quite significant) difference that this flag makes
is the location of governor-specific directory:
- w/o this flag: /sys/devices/system/cpu/cpufreq/<here>
- w/ this flag: /sys/devices/system/cpu/cpu*/cpufreq/<here>

So, is there some issue with the sysfs lock for <cpu*/cpufreq/> node as while
switching governor we change  <cpu*/cpufreq/scaling_governor> at the same
location?

--
viresh

--
viresh
