Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbaFQMQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:16:22 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55235 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbaFQMQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:16:20 -0400
Message-ID: <53A03186.3040703@collabora.com>
Date: Tue, 17 Jun 2014 14:16:06 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com> <539F4D44.3070309@wwwdotorg.org>
In-Reply-To: <539F4D44.3070309@wwwdotorg.org>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 10:02 PM, Stephen Warren wrote:
> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
>> +
>> +Child device nodes describe the memory settings for different configurations and
>> +clock rates.
>
> How do the child nodes do that? The binding needs to specify the format
> of the child node.

Sorry, that file was sent before I had finished removing the bits from 
downstream that aren't needed yet. There's no current need for any child 
nodes.

> This binding looks quite anaemic vs.
> Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-emc.txt; I
> would expect that this binding needs all the EMC register data from the
> tegra20-emc binding too. Can the two bindings be identical?

There's even less stuff needed right now, as all what ultimately the EMC 
driver does is call clk_set_rate on the EMC clock. As the T124 EMC 
driver gains more features, they should get more similar.

> Can you explain what the nvidia,mc and nvidia,pmc references are needed
> for? Hopefully, this driver isn't going to reach into those devices and
> touch their registers directly.

Not really needed, see above.

>> diff --git a/include/linux/platform_data/tegra_emc.h b/include/linux/platform_data/tegra_emc.h
>
> A header file that defines platform data format isn't the correct place
> to put the definitions of public APIs. I'd expect something more like
> <linux/tegra-soc.h>.

Sounds better indeed, thanks.

>> +#ifdef CONFIG_TEGRA124_EMC
>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned long rate);
>> +void tegra124_emc_set_floor(unsigned long freq);
>> +void tegra124_emc_set_ceiling(unsigned long freq);
>> +#else
>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned long rate)
>> +{ return -ENODEV; }
>> +void tegra124_emc_set_floor(unsigned long freq)
>> +{ return; }
>> +void tegra124_emc_set_ceiling(unsigned long freq)
>> +{ return; }
>> +#endif
>
> I'll repeat what I said off-list so that we can have the whole
> conversation on the list:
>
> That looks like a custom Tegra-specific API. I think it'd be much better
> to integrate this into the common clock framework as a standard clock
> constraints API. There are other use-cases for clock constraints besides
> EMC scaling (e.g. some in audio on Tegra, and I'm sure many on other
> SoCs too).

Yes, I wrote a bit in the cover letter about our requirements and how 
they map to the CCF. Could you please comment on that?

Thanks,

Tomeu

> See https://lkml.org/lkml/2014/5/16/569 for some previous discussion on
> this topic.


