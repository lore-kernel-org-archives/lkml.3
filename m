Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbaEQEwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 00:52:07 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:49220 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846AbaEQEwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 00:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <5376696F.9090006@wwwdotorg.org>
References: <9e1ed1bf8c3610709436fe5ef8df3a63856f8f5c.1400230695.git.viresh.kumar@linaro.org>
	<b3e68b08ca8175fde81ef1a85db1fde506f835b9.1400230695.git.viresh.kumar@linaro.org>
	<5376696F.9090006@wwwdotorg.org>
Date: Sat, 17 May 2014 10:22:02 +0530
Message-ID: <CAKohpondZuWyA+oLOTbFHn2D1g6DdNu0PaoTfAau8jXw4VVc3Q@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] cpufreq: Tegra: implement intermediate frequency callbacks
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2014 01:09, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>  static int
>>  tegra_target_intermediate(struct cpufreq_policy *policy, unsigned int frequency)
>>  {
>> +       WARN_ON(frequency != clk_get_rate(pll_p_clk) / 1000);
>> +
>> +       /*
>> +        * Take an extra reference to the main pll so it doesn't turn
>> +        * off when we move the cpu off of it
>> +        */
>> +       clk_prepare_enable(pll_x_clk);
>> +
>>         return clk_set_parent(cpu_clk, pll_p_clk);
>> +       /* FIXME: if error, remove pll_x reference */

Fixed this as well
