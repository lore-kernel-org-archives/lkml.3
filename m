Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaIBWAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:00:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52762 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaIBWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomf4a75G5TYr4U1VkdcRUWO-Hp6oyJPyzfOR=6-GuMBbg@mail.gmail.com>
References: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
 <1409597225-24368-4-git-send-email-mturquette@linaro.org> <CAKohpomf4a75G5TYr4U1VkdcRUWO-Hp6oyJPyzfOR=6-GuMBbg@mail.gmail.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 2 Sep 2014 15:00:17 -0700
Message-ID: <CAPtuhThLdvRMRT0rdd692v6eepzq2J8wDX=DFDwJbuO5B6fMQw@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: kirkwood: use the powersave multiplexer
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 9:49 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 2 September 2014 00:17, Mike Turquette <mturquette@linaro.org> wrote:
>
>> @@ -150,7 +146,7 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>>                 err = PTR_ERR(priv.powersave_clk);
>>                 goto out_ddr;
>>         }
>> -       clk_prepare(priv.powersave_clk);
>> +       clk_prepare_enable(priv.powersave_clk);
>
> Shouldn't this be done in a separate patch? Or is this really related?

It is related. Before this change powersave_clk was modeled as a gate.
The separate clk_enable/clk_disable operations were used to toggle the
mux. This patch does two things:

1) remove the old gate-style powersave_clk in the clock driver and
replace with the mux-style powersave_clk data
2) update the cpufreq driver to handle the mux properly

So the change you pointed out above is part of #2.

These two changes are coupled in one patch to prevent git bisect breakage.

>
>>
>>         of_node_put(np);
>>         np = NULL;
>
> Other than that: Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Yeah, you can take it through clock tree..

Cool.

Thanks,
Mike
