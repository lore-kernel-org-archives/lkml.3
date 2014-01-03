Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaACLTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:19:21 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:59412 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaACLTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:19:18 -0500
MIME-Version: 1.0
In-Reply-To: <871u0po0gx.fsf@nemi.mork.no>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan>
	<87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan>
	<878uuxquxu.fsf@nemi.mork.no>
	<871u0po0gx.fsf@nemi.mork.no>
Date: Fri, 3 Jan 2014 16:49:17 +0530
Message-ID: <CAKohpo=9p8ArfWyyWkdQm_BWtyWbWe_dsg6VAUP60VUFcAjFSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 January 2014 15:23, Bjørn Mork <bjorn@mork.no> wrote:
> Note that "ondemand" and "1401000" are the default vaules, so I don't
> actually change anything here.  The write is causing the problem, not
> the value.  As expected, I guess.
>
> Also note that boot vs non-boot cpu doesn't seem to matter.  Nor does
> cancelling the hibernation.  The warning appears on hibernate - not on
> resume.

Hmm... I spent quite some time understanding whats going on and really
couldn't get across anything as of now. I haven't tried reproducing it though.

Few things that I can make out of this mail chain so far:
- Apart from the log, everything is working fine. i.e. system is back in
working condition.
- It only happens when cpufreq_add_dev() fails during hibernation while
we enable non-boot CPUs again to save image to disk. So, isn't a problem
for a system which doesn't have any issues with add_dev() failing on
hibernation
- There is a contention of locks in the order they are taken. And the contention
looks to be between, hotplug lock taken by cpu_online_cpus() and s_active
lock for sysfs files. Don't know what's the role of previous write to
sysfs files.
As that should finish before hibernation starts and so all locks should be back
in place.

--
viresh
