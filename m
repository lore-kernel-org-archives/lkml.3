Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3FTFF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:05:28 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:38747 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3FTFF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130618154456.56d99e18@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<20130617155156.4c729b5a@amdc308.digital.local>
	<CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
	<3258927.Qds4G9CTyG@vostro.rjw.lan>
	<20130618154456.56d99e18@amdc308.digital.local>
Date: Thu, 20 Jun 2013 10:35:26 +0530
Message-ID: <CAKohpokYq8LyA0B1q2DNC58dhC0kxFzcMgTGnBkACH4FCoDZXQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2013 19:14, Lukasz Majewski <l.majewski@samsung.com> wrote:
> On Tue, 18 Jun 2013 15:26:16 +0200, Rafael J. Wysocki wrote:
>> On Tuesday, June 18, 2013 12:12:13 PM Viresh Kumar wrote:
>> > On 17 June 2013 19:21, Lukasz Majewski <l.majewski@samsung.com>

>> Well, that's why on x86 turbo is controlled by hardware that takes
>> care of keeping things within the chip's thermal limits.
>
> And this is the reason why I don't want to overly change acpi-cpufreq.c
> code. :-)

We need to keep both hardware/software boost features at the same place
in core, they may behave differently though. That's why I wanted you
to do that.

> I think that thermal subsystem shall be the second option to disable SW
> boosting.
>
> The main control shall be done inside the cpufreq core. The idea to
> disable boost when more than one core is active is rational.

But then, it might not be enough. A single core can make your SoC
very hot.
