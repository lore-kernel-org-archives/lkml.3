Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3HGRpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:45:15 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:49997 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3HGRpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:45:12 -0400
MIME-Version: 1.0
In-Reply-To: <52028620.6000608@wwwdotorg.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<8d192a13cb7e088943da40689d62bc6353bd8604.1375886595.git.viresh.kumar@linaro.org>
	<52028620.6000608@wwwdotorg.org>
Date: Wed, 7 Aug 2013 23:15:11 +0530
Message-ID: <CAKohpokVgcMfmKmjkxc9Dr3z6mBKad23uUdB4ydN_xzGHdfedQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] clk: Tegra: Add CPU0 clock driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 August 2013 23:08, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/07/2013 08:46 AM, Viresh Kumar wrote:
>> This patch adds CPU0's clk driver for Tegra. It will be used by the generic
>> cpufreq-cpu0 driver to get/set cpu clk.
>>
>> Most of the platform specific bits are picked from tegra-cpufreq.c.
>
> Hmmm. I'm not sure if it makes sense to represent this as a clock
> object; isn't this more of a virtual construct that manages the rate of
> the clock, rather than an actual clock? The actual clock already exists
> as "cpu".

I see it as this: There is a clock in system for cpu, call it "cpu". Now we
must be able to provide get/set routines for it. A set should set the
frequency to whatever is asked for and should really worry about how
that is being set. This part is internal to "cpu" clk.

This is what cpufreq-cpu0 driver should expect and does. Current "cpu"
clock implemented doesn't provide this facility ? And so this wrapper
made sense to me.
