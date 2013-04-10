Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3DJFbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:31:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35589 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3DJFbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:31:48 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>
Subject: RE: [PATCH v3 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
Thread-Topic: [PATCH v3 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
Thread-Index: AQHOKS19PuoEahWsUk2VKlRRhE1ixJjCSvgAgAnS9HD//+hBgIABcNbQgAAHFYCAAXwoQA==
Date: Wed, 10 Apr 2013 05:30:15 +0000
Deferred-Delivery: Wed, 10 Apr 2013 05:30:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAAB235@DBDE01.ent.ti.com>
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
 <1364197789-16783-4-git-send-email-avinashphilip@ti.com>
 <515A97DE.1080403@ti.com>
 <518397C60809E147AF5323E0420B992E3EAA91B6@DBDE01.ent.ti.com>
 <5162C1A5.5060808@ti.com>
 <518397C60809E147AF5323E0420B992E3EAA9DA3@DBDE01.ent.ti.com>
 <5163FCFD.6070606@ti.com>
In-Reply-To: <5163FCFD.6070606@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3A5VtM6009679

On Tue, Apr 09, 2013 at 17:05:25, Nori, Sekhar wrote:
> On 4/9/2013 2:12 PM, Philip, Avinash wrote:
> > On Mon, Apr 08, 2013 at 18:39:57, Nori, Sekhar wrote:
> >>
> >> On 4/8/2013 2:39 PM, Philip, Avinash wrote:
> >>> On Tue, Apr 02, 2013 at 14:03:34, Nori, Sekhar wrote:
> >>>> On 3/25/2013 1:19 PM, Philip Avinash wrote:
> >>>>> Add da850 EHRPWM & ECAP DT node.
> >>>>> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
> >>>>> clock.
> >>>>
> >>>> This looks fine to me but I will wait for the bindings to get accepted
> >>>> before taking this one.
> >>>
> >>> Sekhar,
> >>>
> >>> Binding document got accepted in PWM tree [1].
> >>> Can you accept this patch?
> >>
> >> Can you also add the pinmux definitions and resend just this patch?
> >> Sorry I did not notice those were missing earlier.
> > 
> > According to latest schematics, ECAP instance 2 being used for PWM backlight
> > control. Should I add pin-mux only for ECAP2 or for all PWM instances?
> 
> I meant add definitions in .dtsi. Since there is only one pin a given
> functionality can be present on in DaVinci, it can be done in a board
> independent manner.

I think here the expectation would be that .dtsi should populate the complete
pin-mux for SOC and board files should just be able to re-use it (add it as a phandler).
Also as per the above description .dtsi file will end up contain majorly pin-mux info
rather than the hardware data. Is it a good idea?

On looking da850.dtsi file NAND pins were defined for 8-bit part. 
In case of NAND flash, the device might be sitting under different chip-select or may
have 16 bit part on  different boards. So pin-mux defined in soc.dtsi has to be split
separately for CS, DATA, Address.

So it is always challenging to create pin-mux info in .dtsi file. So more useful/meaningful
way is to actually create pin-mux in board file rather in .dtsi file.

> See examples for other peripherals in existing
> da850.dtsi file.

I have gone through .dtsi. But it didn't describe the complete pin-mux like I2C1, MMC1, etc.
So the expectation here is only to add ECAP2 pin-mux. Is it correct?

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
