Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3LQGzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:55:00 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35991 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3LQGyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:54:43 -0500
MIME-Version: 1.0
In-Reply-To: <1386229462-3474-3-git-send-email-bilhuang@nvidia.com>
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
	<1386229462-3474-3-git-send-email-bilhuang@nvidia.com>
Date: Tue, 17 Dec 2013 12:24:42 +0530
Message-ID: <CAKohponns4B+BPPum3EN6EuXx6U+6MzOa50gMdR1BNBtxMNf0Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Bill Huang <bilhuang@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2013 13:14, Bill Huang <bilhuang@nvidia.com> wrote:
> Re-model Tegra cpufreq driver to support all Tegra series of SoCs.
>
> * Make tegra-cpufreq.c a generic Tegra cpufreq driver.
> * Move Tegra20 specific codes into tegra20-cpufreq.c.
> * Bind Tegra cpufreq dirver with a fake device so defer probe would work
>   when we're going to get regulator in the driver to support voltage
>   scaling (DVFS).

I strongly feel we must reuse cpufreq-cpu0 driver here after adding a
clk/regulator driver for tegra to support all that.

@Stephen: If you want we can keep all that tegra specific stuff
(clk/regulator) in
tegra-cpufreq.c, but we can easily use cpufreq-cpu0 driver without much
complications..

I have tried it earlier, got some comments and then got busy in other stuff..
https://lkml.org/lkml/2013/8/7/364

>  static int tegra_cpu_exit(struct cpufreq_policy *policy)
>  {
> -       clk_disable_unprepare(cpu_clk);
> -       clk_disable_unprepare(emc_clk);
> +       cpufreq_frequency_table_cpuinfo(policy, tegra_data->freq_table);

Btw, why do you need this here?
