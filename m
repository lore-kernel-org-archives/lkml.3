Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3KVNNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:13:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62276 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752069Ab3KVNNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:13:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Kukjin Kim <kgene@kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>
Subject: Re: [PATCH V2 2/2] cpufreq: Change freq before suspending governors
Date: Fri, 22 Nov 2013 14:25:59 +0100
Message-ID: <4592811.7DNNYfo4cW@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpo=RWi1nRUJq4qx8K+Y7swMDaqwEOH24-KfBCMgdbW=hMQ@mail.gmail.com>
References: <cover.1385118255.git.viresh.kumar@linaro.org> <2783049.JzUB2QcsZz@vostro.rjw.lan> <CAKohpo=RWi1nRUJq4qx8K+Y7swMDaqwEOH24-KfBCMgdbW=hMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 22, 2013 06:22:52 PM Viresh Kumar wrote:
> On 22 November 2013 18:07, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Friday, November 22, 2013 04:59:49 PM Viresh Kumar wrote:
> >> Some platforms might want to change frequency before suspending governors. Like:
> >> - Some platform which want to set freq to max to speed up suspend/hibernation
> >>   process.
> >> - Some platform (like: Tegra or exynos), set this to min or bootloader's
> >>   frequency.
> >>
> >> This patch adds an option for those, so that they can specify this at call to
> >> ->init(), so that cpufreq core can take care of this before suspending system.
> >>
> >> If this variable is not updated by ->init() then its value would be zero and so
> >> core wouldn't do anything.
> >>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >
> > I don't think this is generally necessary, because the suspend/resume routines
> > added by patch [1/2] will be executed very late during suspend or very early
> > during resume and it shouldn't really matter what performance levels the CPUs
> > are at then.
> 
> There are few things here:
> - I feel that the current place from where we have suspended stuff is not gonna
> fly. We are doing that in noirq and probably devices which might be required
> during frequency transitions might already be down.. So we *may* need to
> move that in dpm_suspend()..

That would be a much more intrusive change.  Definitely not 3.13 material
at this point.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
