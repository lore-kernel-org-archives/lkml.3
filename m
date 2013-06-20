Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab3FTPm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:42:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39698 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab3FTPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:42:54 -0400
MIME-Version: 1.0
In-Reply-To: <51C2E509.2030800@samsung.com>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
	<CAKohponD5s6-g0X9rgsVt0U4RutfyXSQJRZP3vT7EuczgMMQ2Q@mail.gmail.com>
	<51C2DD3D.5040601@samsung.com>
	<CAKohpomx54Y3WVToYP0nOw-hsxKzGjp2nyfzWf5bo1s530Yg1w@mail.gmail.com>
	<51C2E0AD.8060208@samsung.com>
	<51C2E509.2030800@samsung.com>
Date: Thu, 20 Jun 2013 21:12:53 +0530
Message-ID: <CAKohpo=0m8+WegUmMR2BOKeY2mJZw=X5-nEAp26M5L3PH9Bz2A@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 June 2013 16:48, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> But,
> To show old frequency/new frequency on load_table debugfs file,
> governor function(dbs_check_cpu()) pass calculated CPUs load to specific governor(e.g., ondemand)
> as below function flow.
>
> dbs_check_cpu() (in cpufreq.c)
> -> od_check_cpu() (in cpufreq_ondemand.c)
> -> __cpufreq_driver_target() (in cpufreq.c)
> -> cpufreq_driver->target(policy)
>
> Also, The __cpufreq_driver_target() is external function which can be called on other file
> so I must consider exception case.
>
> If send CPUFREQ_LOADCHECK noti after changed cpu frequency,
> I think it is complicated and has quite a little difficulty.
>
> What is your opinion?

What you can do is:
- create another routine: cpufreq_governor_driver_target()
- replace all __cpufreq_driver_target() from ondemand/conservative governors
with this one
- In cpufreq_governor_driver_target() call __cpufreq_driver_target() and
take a note of new freq.

Maybe you don't need to check the actual freq that is set (even
that would be simple to implement), but what is requested.
