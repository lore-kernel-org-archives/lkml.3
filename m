Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3H0VJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:09:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37719 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab3H0VJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:09:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [Query] CPUFreq: Why do we need policy->user_policy?
Date: Tue, 27 Aug 2013 23:20:32 +0200
Message-ID: <1734682.b8u1f0b3XY@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAOLK0pztfCd9ov297t0CW0C5S2iOSb9FJFHq9ycqwYGRiyifmA@mail.gmail.com>
References: <CAKohponkO6oZrvrsUGVK0uUbAM5wse7eHd7udtWkab7y2aatGA@mail.gmail.com> <CAKohpo=ZKA6ieg9BrVRCRL+_7uiPfb2tWMO0_VOYx0m=Sv4+xQ@mail.gmail.com> <CAOLK0pztfCd9ov297t0CW0C5S2iOSb9FJFHq9ycqwYGRiyifmA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 27, 2013 10:04:52 PM Lan Tianyu wrote:
> 2013/8/27 Viresh Kumar <viresh.kumar@linaro.org>:
> > On 26 August 2013 20:53, Lan Tianyu <lantianyu1986@gmail.com> wrote:
> >> So far as I know, it stores some user's config and cpufreq_update_policy()
> >> bases on the data in the struct to start a new policy. Cpu thermal driver
> >> （/driver/thermal/cpu_cooling.c）also will its value to update freq policy
> >> when receive a cpufreq policy adjust notification.
> >
> > Yeah, but how are these different from policy->min/max/policy/governor?
> > Why do we need to replicate this information?
> 
> From my understanding.policy->min/max may be modified by some drivers
> but the user_policy only store user space config and should not be changed
> by other reason.  :)

Yes, that was the original idea IIRC, so separate user settings from stuff that
may be changed internally by the kernel.

Thanks,
Rafael

