Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3JANTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:19:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44249 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3JANTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:19:17 -0400
Message-ID: <524ACBC6.5060208@ti.com>
Date: Tue, 1 Oct 2013 18:49:02 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <luca@coelho.fi>
Subject: Re: using mmc2 on panda [was: Regression 3.11-rc1: omap4panda: no
 usb and consequently no ethernet]
References: <51E7AA24.6080600@broadcom.com> <20130718085951.GT7656@atomide.com> <51E916C0.8080206@broadcom.com> <51E919CA.8060805@ti.com> <51E91B80.1050609@broadcom.com> <524A823F.6070209@broadcom.com> <524A9AB8.4010407@ti.com> <524A9BB2.2050503@ti.com> <524AA9C1.2000303@broadcom.com> <524ABD60.1010206@ti.com>
In-Reply-To: <524ABD60.1010206@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> Hi Roger,
>>>>>
>>>>> It has been a while, but I would like to pickup this thread. We have a couple of pandaboards used as test setup. These have an SDIO adapter hooked up to expansion connector A using MMC2. I have attached the patch file (just ignore platform_data stuff). Now on one board it works, but not for the other. I suspect a board issue so listing the two types that we use:
>>>>>
>>>>> PandaBoard rev A2 (dmesg: OMAP4430 ES2.1): works
>>>>> PandaBoardES rev B1 (dmesg: OMAP4460 ES1.1): nope
>>>>>
>>>>> Any hints for me.
>>>>
>>>> Does your PandaboardES have the WLAN chip (U4) mounted? If yes, how do you isolate
>>>> it from your external SDIO adapter?
>>
>> On my 4460 board in front of me U4 is not populated, but U3 is (the TiWi thing).
>>
>>>
>>> OK, just realized that the expansion connector uses different pads for MMC2. However, you still
>>> need to make sure that the other pins (connected to on board WLAN chip) are not muxed as MMC2.
>>
>> I think Luciano added DT patches for on-board WLAN and it uses MMC5 if I am not mistaken(?). Attached are the dmesg logs of the two boards.
>
> Right. WLAN is supposed to use MMC5. But if you don't have Luca's patches, can you please ensure that those pins are muxed either as safe mode
> or as MMC5? Default seems to be safe mode, but you should cross check.
>
> Also in your patches you have set mmc2-clk to PIN_INPUT_PULLUP
> Shouldn't it be PIN_OUTPUT?
>
> Still I have no clue why it works on 4430 and not on 4460. Are you using the same bootloader image on both boards?
>
if you are using vaux1, can you check the voltage levels,

 From dmesg you attached,
vaux1 is set to 1.8V on omap4430 and to 2.8V on OMAP4460

4430
[    2.425750] VAUX1_6030: 1000 <--> 3000 mV at 1800 mV

4460
[    2.244262] VAUX1_6030: 1000 <--> 3000 mV at 2800 mV

Can you also check with MMC_DEBUG enabled for any clues.

> cheers,
> -roger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

