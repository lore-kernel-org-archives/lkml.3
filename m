Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3CYQX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:23:58 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47936 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab3CYQX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:23:57 -0400
Message-ID: <51507A1A.6050802@free-electrons.com>
Date: Mon, 25 Mar 2013 17:23:54 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com
Subject: Re: [PATCH 03/10] clocksource: sunxi: make use of CLKSRC_OF
References: <1364218233-29636-1-git-send-email-maxime.ripard@free-electrons.com> <1364218233-29636-4-git-send-email-maxime.ripard@free-electrons.com> <5150561E.2070103@gmail.com>
In-Reply-To: <5150561E.2070103@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Le 25/03/2013 14:50, Rob Herring a écrit :
> On 03/25/2013 08:30 AM, Maxime Ripard wrote:
>> Using CLKSRC_OF allows to remove the SoC specific sunxi_timer.h header,
>> and instead of using a custom init function in the machine definition
>> use the standard clocksource_of_init function.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> [...]
> 
>> @@ -158,3 +157,5 @@ void __init sunxi_timer_init(void)
>>  	clockevents_config_and_register(&sunxi_clockevent, rate / TIMER_SCAL,
>>  					0x1, 0xff);
>>  }
>> +CLOCKSOURCE_OF_DECLARE(sunxi, "allwinner,sun4i-timer",
>> +		       sunxi_timer_init);
> 
> You should base this on clocksource clean-up branch "clksrc/cleanup" in
> arm-soc. That will get rid of double matching and match table.
> 
> Also, sunxi_timer_init can be static now.

Ah, thanks, I missed these patches.

I'll do that and send a v2.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
