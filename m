Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3HACAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:00:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52981 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3HACAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:00:12 -0400
Message-ID: <51F9C0FF.7030703@ti.com>
Date: Wed, 31 Jul 2013 20:59:27 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 7/9] ARM: edma: Don't clear EMR of channel in edma_stop
References: <1375104595-16018-1-git-send-email-joelf@ti.com> <1375104595-16018-8-git-send-email-joelf@ti.com> <51F77982.7030601@ti.com> <51F89B0B.4080803@ti.com> <51F8DA5C.9060503@ti.com>
In-Reply-To: <51F8DA5C.9060503@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 04:35 AM, Sekhar Nori wrote:
> On Wednesday 31 July 2013 10:35 AM, Joel Fernandes wrote:
>> On 07/30/2013 03:29 AM, Sekhar Nori wrote:
>>> On Monday 29 July 2013 06:59 PM, Joel Fernandes wrote:
>>>> We certainly don't want error conditions to be cleared anywhere
>>>
>>> 'anywhere' is a really loaded term.
>>>
>>>> as this will make us 'forget' about missed events. We depend on
>>>> knowing which events were missed in order to be able to reissue them.
>>>
>>>> This fixes a race condition where the EMR was being cleared
>>>> by the transfer completion interrupt handler.
>>>>
>>>> Basically, what was happening was:
>>>>
>>>>             Missed event
>>>>              |
>>>>              |
>>>>              V
>>>> SG1-SG2-SG3-Null
>>>>          \
>>>>           \__TC Interrupt (Almost same time as ARM is executing
>>>> TC interrupt handler, an event got missed and also forgotten
>>>> by clearing the EMR).
>>>
>>> Sorry, but I dont see how edma_stop() is coming into picture in the race
>>> you describe?
>>
>> In edma_callback function, for the case of DMA_COMPLETE (Transfer
>> completion interrupt), edma_stop() is called when all sets have been
>> processed. This had the effect of clearing the EMR.
> 
> Ah, thanks. I was missing the fact that the race comes into picture only
> when using the DMA engine driver. I guess that should be mentioned
> somewhere since it is not immediately obvious.
> 
> The patch looks good to me. So if you respin just this one with some
> updated explanation based on what you wrote below, I will take it.

Sure I'll do that. Also the trigger_channel patch, will you be taking
that one too? I can send these 2 in a series as they touch
arch/arm/common/edma.c

Thanks,

-Joel



> 
> Thanks,
> Sekhar
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

