Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaGBEM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:12:58 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:60456 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaGBEM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:12:56 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Date: Wed, 2 Jul 2014 09:42:55 +0530
Message-ID: <CAKohpomRttWnCBGEpR3cVsGYniJSnjWUnvtbg21AiYyrUnDjGw@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>, linux-arm-msm@vger.kernel.org,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 July 2014 22:02, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> V1: https://lkml.org/lkml/2014/6/25/152
>
> Stephen Boyd sent few patches some time back around a new cpufreq driver for
> Qualcomm's Krait SoC: https://lkml.org/lkml/2014/6/24/918.
>
> Krait couldn't use existing cpufreq-cpu0 driver as it doesn't have support for
> SoC's with multiple clusters or SoC's which don't share clock line across all
> CPUs.
>
> This patchset is all about extending support beyond CPU0. It can be used for
> platforms like Krait or ARM big LITTLE architecture now.
>
> First two patches add helper routine for of and clk layer, which would be used
> by later patches.
>
> Third one adds space for driver specific data in 'struct cpufreq_policy' and
> later ones migrate cpufreq-cpu0 to cpufreq-generic, i.e. can be used for SoCs
> which don't share clock lines across all CPUs.
>
> @Stephen: I haven't added your Tested-by as there were few modifications since
> the time you tested it last.
>
> Pushed here:
> Rebased over v3.16-rc3:
> git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-krait-v2

Hi Stephen,

As suggested by you I have updated patch

7/14: cpufreq: cpu0: OPPs can be populated at runtime
12/14: cpufreq: cpu0: Extend support beyond CPU0

and dropped
2/14: clk: Create of_clk_shared_by_cpus()

Please see if they look fine and work for you.

git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-krait-v3
