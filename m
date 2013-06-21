Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161453Ab3FUNET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:04:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45431 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161222Ab3FUNEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:04:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show accumulated data of CPUs
Date: Fri, 21 Jun 2013 15:13:39 +0200
Message-ID: <5527616.jZ71Fx7IV6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51C3D01F.7040907@samsung.com>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com> <CAKohpo=0m8+WegUmMR2BOKeY2mJZw=X5-nEAp26M5L3PH9Bz2A@mail.gmail.com> <51C3D01F.7040907@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 21, 2013 01:01:35 PM Chanwoo Choi wrote:
> On 06/21/2013 12:42 AM, Viresh Kumar wrote:
> > On 20 June 2013 16:48, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> >> But,
> >> To show old frequency/new frequency on load_table debugfs file,
> >> governor function(dbs_check_cpu()) pass calculated CPUs load to specific governor(e.g., ondemand)
> >> as below function flow.
> >>
> >> dbs_check_cpu() (in cpufreq.c)
> >> -> od_check_cpu() (in cpufreq_ondemand.c)
> >> -> __cpufreq_driver_target() (in cpufreq.c)
> >> -> cpufreq_driver->target(policy)
> >>
> >> Also, The __cpufreq_driver_target() is external function which can be called on other file
> >> so I must consider exception case.
> >>
> >> If send CPUFREQ_LOADCHECK noti after changed cpu frequency,
> >> I think it is complicated and has quite a little difficulty.
> >>
> >> What is your opinion?
> > 
> > What you can do is:
> > - create another routine: cpufreq_governor_driver_target()
> > - replace all __cpufreq_driver_target() from ondemand/conservative governors
> > with this one
> > - In cpufreq_governor_driver_target() call __cpufreq_driver_target() and
> > take a note of new freq.
> > 
> > Maybe you don't need to check the actual freq that is set (even
> > that would be simple to implement), but what is requested.
> > 
> 
> OK, I understand and will try to implement it.
> Thanks.
> 
> @Rafael?
> If possible, I want to know the your opinion about this.

Well, to be honest, I don't like the whole thing.  The more changes you need
to make to the common code to support it, the worse.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
