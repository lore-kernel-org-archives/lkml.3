Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaFBKBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:01:23 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:57916 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaFBKBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <53877199.5090009@wwwdotorg.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>
	<537E285C.6060608@wwwdotorg.org>
	<CAKohpomdOEspgfxNR5p=PVLCeSUYcUWZ2cWGGQo0b__ptKiYtw@mail.gmail.com>
	<53877199.5090009@wwwdotorg.org>
Date: Mon, 2 Jun 2014 15:31:20 +0530
Message-ID: <CAKohpokeHPfKHBEVqAtm7d+nSDTWM+HwOQt_6BCgU=DCY=trXg@mail.gmail.com>
Subject: Re: [PATCH V4 3/3] cpufreq: Tegra: implement intermediate frequency callbacks
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2014 23:12, Stephen Warren <swarren@wwwdotorg.org> wrote:

> E.g. in the following code after the series is applied:
>
>>       ret = clk_set_rate(pll_x_clk, rate * 1000);
>>       /* Restore to earlier frequency on error, i.e. pll_x */
>>       if (ret)
>>               pr_err("Failed to change pll_x to %lu\n", rate);
>>
>>       ret = clk_set_parent(cpu_clk, pll_x_clk);
>
> If the clk_set_rate() failed, we have no idea what the pll_x rate is; I
> don't think the clock API guarantees that zero HW changes have been made
> if the function fails. Yet the code switches the CPU clock back to pll_x
> without attempting to fix the pll_x rate to be the old rate. Perhaps
> there's not much that can be done here though, since if one
> clk_set_rate() failed, perhaps the one to fix it will too.

This was the case here with the existing driver as well. CPUFreq core
expects this today as well and so sends reverse notification in case of
failures.

> I suspect there are other issues, like switching between pll_p/pllx
> might not be restored on error

Another example would be useful..

> and the EMC frequency isn't switched back, etc.

It wasn't in the existing code as well and so left it as is..
