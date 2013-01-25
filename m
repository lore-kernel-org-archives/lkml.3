Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3AYLEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:04:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55493 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab3AYLEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:04:47 -0500
From: "Katepallewar, Mrugesh" <mrugesh.mk@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>, "hs@denx.de" <hs@denx.de>
Subject: RE: [PATCH] ARM: davinci: da850: add RTC driver DT entries
Thread-Topic: [PATCH] ARM: davinci: da850: add RTC driver DT entries
Thread-Index: AQHN+ueMhVlYjW+vU023okApW3sQOZhZ3ToQ
Date: Fri, 25 Jan 2013 11:04:32 +0000
Message-ID: <4232EB8829679242B82E712C3DB3149D4233E9@DBDE01.ent.ti.com>
References: <1359094430-14724-1-git-send-email-mrugesh.mk@ti.com>
 <51025FAE.3060503@ti.com>
In-Reply-To: <51025FAE.3060503@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0PB4oLV019767

On Fri, Jan 25, 2013 at 16:04:22, Nori, Sekhar wrote:
> On 1/25/2013 11:43 AM, Mrugesh Katepallewar wrote:
> > Add RTC DT entries in da850 dts file.
> > 
> > Signed-off-by: Mrugesh Katepallewar <mrugesh.mk@ti.com>
> > ---
> > Applies on top of v3.8-rc4 of linus tree.
> > 
> > Tested on da850-evm device.
> > 
> > Test Procedure:
> > date [YYYY.]MM.DD-hh:mm[:ss]
> > hwclock -w
> > reset board and check system time.
> > 
> > :100644 100644 37dc5a3... b16efd4... M	arch/arm/boot/dts/da850-evm.dts
> > :100644 100644 640ab75... a8eb1b1... M	arch/arm/boot/dts/da850.dtsi
> >  arch/arm/boot/dts/da850-evm.dts |    3 +++
> >  arch/arm/boot/dts/da850.dtsi    |    8 ++++++++
> >  2 files changed, 11 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/da850-evm.dts 
> > b/arch/arm/boot/dts/da850-evm.dts index 37dc5a3..b16efd4 100644
> > --- a/arch/arm/boot/dts/da850-evm.dts
> > +++ b/arch/arm/boot/dts/da850-evm.dts
> > @@ -24,5 +24,8 @@
> >  		serial2: serial@1d0d000 {
> >  			status = "okay";
> >  		};
> > +		rtc@1c23000 {
> > +			status = "okay";
> > +		};
> >  	};
> >  };
> > diff --git a/arch/arm/boot/dts/da850.dtsi 
> > b/arch/arm/boot/dts/da850.dtsi index 640ab75..a8eb1b1 100644
> > --- a/arch/arm/boot/dts/da850.dtsi
> > +++ b/arch/arm/boot/dts/da850.dtsi
> > @@ -56,5 +56,13 @@
> >  			interrupt-parent = <&intc>;
> >  			status = "disabled";
> >  		};
> > +		rtc@1c23000 {
> > +			compatible = "ti,da830-rtc";
> > +			reg = <0x23000 0x1000>;
> > +			interrupts = <19
> > +				      19>;
> 
> Why two interrupts of the same number? If there is only one interrupt line then only one should be specified, no?
We are using common OMAP RTC driver for da850 and other ti SoC's (e.g.am33xx). I have seen in am33xx.dtsi rtc timer
and alarm interrupts are different. So, two interrupt numbers are expected from RTC DT node.
> 
> Thanks,
> Sekhar
> 


Regards, 
Mrugesh
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
