Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaEOQab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:30:31 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51237 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaEOQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:30:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Cc: Bart Tanghe <bart.tanghe@thomasmore.be>, thierry.reding@gmail.com,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, grant.likely@linaro.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc]pwm: add xilinx pwm driver
Date: Thu, 15 May 2014 18:30:13 +0200
Message-ID: <16896948.U7hTsgDub4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5374C773.6070402@monstr.eu>
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be> <5049141.XmehsUeakV@wuerfel> <5374C773.6070402@monstr.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ei0W0zHWg9vPFNxoAUqNEUWvIy4lMeQ6E5yADRwmdVU
 lOPu6j93qzub4wxCTXOAj73Uf4FtuLq0VkVK45AfFaHZcIashf
 I+H4yrfRxcMITniCTd2TCNiq+ZaJuOh0FcUESx9xXjOshTfLql
 m2vde3QMoqVkuSMqG2xn1jFHEwJXMw7Y+urKFaZ/1l0GrwMUir
 R/Se0uz5nsTmx3M3pbo8jAHoQxvzPwJVwU0F28CAJNQpBe/dQa
 3CsZvXlmvxUXmvYvsYgVCruL+9Y5Wap8RPyr4GksneQcVKLqbn
 tar/7U/6+cXIvjPmibhnr8dIkXZYIHhH/CUyesiJlPjIse34tr
 hZ5F0sX9TzlVD7XNFrEo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 15:56:03 Michal Simek wrote:
> IP is configurable as is normal for us.
> You can select IP with just one timer.
> It means register locations for specific timer are fixed.
> http://www.xilinx.com/support/documentation/ip_documentation/xps_timer.pdf
> 
> timer0 - offset 0x0
> timer1 - offset 0x10 (doesn't need to be synthesized)
> 
> There is one interrupt for both timers.
> 
> Timers can be as timers (up/down count/ reload with or without IRQs)
> But then one options is to use both timers and generate PWM signal.
> From full ip description in DT you can see xlnx,gen0-assert = <1>;
> which can suggest that this IP can output PMW signal.
> (We can also detect if PWM0 signal is connected just to be sure
> that PWM can be enabled).
> 
> There is also capture trigger mode where external signal start/stop
> timer counting.
> 
> It means there are 3 modes - timer, capture and PWM.
> Timer (clocksource, clockevent) requires specific handling,
> PWM has own subsystem and not sure if there is any subsystem for
> capture mode. Is there any?

I don't think so. Possibly somewhere in IIO.

> Not every timer configuration is suitable for all things
> but fully configured timer can be used in all 3 modes.
> 
> 
> I think that make sense to register and map all timers in the system
> and classify them with flags (like can't be used for capture or PMW
> if there are not outputs connected) and then use the best
> timer for clocksource and clockevent. The best candidate is IP
> with the lowest IRQ number in dual timer mode but in general
> whatever timer can be used that's why we can't probably avoid
> timer specification in DT.
> In spite of this smells because you are saying via DT
> to Linux which timer should be used for what purpose.

We had discussions about this in the past, but I don't remember the
outcome of that.

	Arnd
