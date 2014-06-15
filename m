Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaFOVer (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 17:34:47 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53448 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaFOVem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 17:34:42 -0400
Message-ID: <539E116D.6030002@linaro.org>
Date: Sun, 15 Jun 2014 23:34:37 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        florian.vaussard@epfl.ch, jic23@kernel.org, jason@lakedaemon.net,
        andrew@lunn.ch, silvio.fricke@gmail.com, heiko.stuebner@bq.com,
        olof@lixom.net, sebastian.hesselbarth@gmail.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        shawn.guo@freescale.com, anders.berg@lsi.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 2/7] clocksource: Add support for the Mediatek SoCs
References: <1402490055-15197-1-git-send-email-matthias.bgg@gmail.com> <1402490055-15197-3-git-send-email-matthias.bgg@gmail.com> <alpine.DEB.2.10.1406112012460.5170@nanos>
In-Reply-To: <alpine.DEB.2.10.1406112012460.5170@nanos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 08:14 PM, Thomas Gleixner wrote:
> On Wed, 11 Jun 2014, Matthias Brugger wrote:
>> +static void mtk_clkevt_mode(enum clock_event_mode mode,
>> +				struct clock_event_device *clk)
>> +{
>> +	struct mtk_clock_event_device *evt = to_mtk_clk(clk);
>> +
>> +	mtk_clkevt_time_stop(evt, GPT_CLK_EVT);
>> +
>> +	switch (mode) {
>> +	case CLOCK_EVT_MODE_PERIODIC:
>> +		mtk_clkevt_time_setup(evt, evt->ticks_per_jiffy, GPT_CLK_EVT);
>> +		mtk_clkevt_time_start(evt, true, GPT_CLK_EVT);
>> +		break;
>> +	case CLOCK_EVT_MODE_ONESHOT:
>> +		mtk_clkevt_time_start(evt, false, GPT_CLK_EVT);
>
> Why start the timer here? The code will call set next event right away.
>
>> +		break;
>> +	case CLOCK_EVT_MODE_UNUSED:
>> +	case CLOCK_EVT_MODE_SHUTDOWN:
>> +	default:
>> +		/* No more interrupts will occur as source is disabled */
>> +		break;
>> +	}
>> +}
>
> Looks good otherwise.

Hi Thomas,

Can I consider the 8.1 patch (the one taking into account your comment) 
as acked-by ?

Thanks

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

