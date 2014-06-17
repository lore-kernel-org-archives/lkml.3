Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965779AbaFQQ7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:59:53 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:55856 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934149AbaFQQ7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:59:50 -0400
Message-ID: <53A073F7.20700@kapsi.fi>
Date: Tue, 17 Jun 2014 19:59:35 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com> <539F4D44.3070309@wwwdotorg.org> <53A03186.3040703@collabora.com> <53A069B6.6070902@wwwdotorg.org>
In-Reply-To: <53A069B6.6070902@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:be5f:f4ff:fe47:6518
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 07:15 PM, Stephen Warren wrote:
> On 06/17/2014 06:16 AM, Tomeu Vizoso wrote:
>> On 06/16/2014 10:02 PM, Stephen Warren wrote:
>>> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
>
>>> This binding looks quite anaemic vs.
>>> Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-emc.txt; I
>>> would expect that this binding needs all the EMC register data from the
>>> tegra20-emc binding too. Can the two bindings be identical?
>>
>> There's even less stuff needed right now, as all what ultimately the EMC
>> driver does is call clk_set_rate on the EMC clock. As the T124 EMC
>> driver gains more features, they should get more similar.
>
> IIRC, even changing the EMC clock rate requires modifying the memory
> controller's programming (e.g. delays/taps/tuning etc.). That's exactly
> what the more complex stuff in the nvidia,tegra20-emc.txt is all about.
> I not convinced that a driver that just modifies the clock rate without
> adjusting the EMC programming will work reliably.

Indeed, changing the EMC clock rate is a somewhat complicated sequence 
of ~10 steps. The kernel even won't let one the rate be change directly, 
as the change would be propagated to PLL_M which cannot have its rate 
changed while it is enabled. I suppose the sequence should be hidden in 
the EMC clk's set_rate implementation, which I guess would leave just 
the rate policy to this driver.

