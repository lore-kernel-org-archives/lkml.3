Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaGBFzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:55:40 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:46822 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaGBFzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140702055330.GA3454@dragon>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<eb6df0f1f2c82db0d516b9b63820cfe0c0c97d5c.1404231535.git.viresh.kumar@linaro.org>
	<20140702055330.GA3454@dragon>
Date: Wed, 2 Jul 2014 11:25:38 +0530
Message-ID: <CAKohpomzPHRghqHD7-tDbj0gXzc=ANEb3qLv2kRKOZUyqatBew@mail.gmail.com>
Subject: Re: [PATCH 06/14] cpufreq: cpu0: defer probe if clock isn't
 registered yet
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 July 2014 11:23, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, Jul 01, 2014 at 10:02:35PM +0530, Viresh Kumar wrote:

>> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
>> index 4273a5f..b5b8e1c 100644
>> --- a/drivers/cpufreq/cpufreq-cpu0.c
>> +++ b/drivers/cpufreq/cpufreq-cpu0.c
>> @@ -150,8 +150,17 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>>
>>       cpu_clk = clk_get(cpu_dev, NULL);
>>       if (IS_ERR(cpu_clk)) {
>> -             ret = PTR_ERR(cpu_clk);
>
> If you keep this ...
>
>> -             pr_err("failed to get cpu0 clock: %d\n", ret);
>> +             /*
>> +              * If cpu's clk node is present, but clock is not yet
>> +              * registered, we should try defering probe.
>> +              */
>> +             if (PTR_ERR(cpu_clk) == -EPROBE_DEFER) {
>
> ... you can use 'ret' here ...
>
>> +                     dev_err(cpu_dev, "cpu0 clock not ready, retry\n");
>> +                     ret = -EPROBE_DEFER;
>
> ... this can be saved ...
>
>> +             } else {
>> +                     ret = PTR_ERR(cpu_clk);
>
> ... and this as well.

All accepted. Thanks.
