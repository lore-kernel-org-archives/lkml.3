Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaGJLT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:19:56 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:62822 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaGJLTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <53BD5564.2060704@ti.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<1ba7771e910084cd0820c19ca5994fe1b3d6451d.1404231535.git.viresh.kumar@linaro.org>
	<53BD5564.2060704@ti.com>
Date: Thu, 10 Jul 2014 16:49:52 +0530
Message-ID: <CAKohpo=KUktq8XJv7Ayis1Q3ik+Wh3wb8wN6VpRAtOsbbv9XCw@mail.gmail.com>
Subject: Re: [PATCH 07/14] cpufreq: cpu0: OPPs can be populated at runtime
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 20:14, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> Assuming you are updating bidnings as suggested by Stephen,
> patch looks good to me.
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Why do you still have a separate cpufreq driver for omap?
Would this patch help getting that out?

I see this for omap:

static inline void omap_init_cpufreq(void)
{
        struct platform_device_info devinfo = { };

        if (!of_have_populated_dt())
                devinfo.name = "omap-cpufreq";
        else
                devinfo.name = "cpufreq-generic";
        platform_device_register_full(&devinfo);
}

and it makes me believe that you were just waiting for this patch?
