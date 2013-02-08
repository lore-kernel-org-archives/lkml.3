Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab3BHBvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:51:24 -0500
Received: from nasmtp02.atmel.com ([204.2.163.16]:5879 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3BHBvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:51:23 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: RE: [v4 PATCH 12/12] ARM: dts: add spi nodes for the atmel boards
Thread-Topic: [v4 PATCH 12/12] ARM: dts: add spi nodes for the atmel boards
Thread-Index: AQHN8irD1CwgvSpvHUWfH15IC76BbZhrSY4AgADiliCAAydTIA==
Date: Fri, 8 Feb 2013 01:51:09 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A0875A3@penmbx02>
References: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com>
 <1358148877-18679-13-git-send-email-wenyou.yang@atmel.com>
 <20130205195008.GA30595@game.jcrosoft.org> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r181pgKW000838

Hello, JC

> -----Original Message-----
> From: Yang, Wenyou
> Sent: 2013Äê2ÔÂ6ÈÕ 9:35
> To: 'Jean-Christophe PLAGNIOL-VILLARD'
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas; richard.genoud@gmail.com; Lin, JM; linux@arm.linux.org.uk
> Subject: RE: [v4 PATCH 12/12] ARM: dts: add spi nodes for the atmel boards
> 
> 
> 
> > -----Original Message-----
> > From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
> > Sent: 2013Äê2ÔÂ6ÈÕ 3:50
> > To: Yang, Wenyou
> > Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> Ferre,
> > Nicolas; richard.genoud@gmail.com; Lin, JM; linux@arm.linux.org.uk
> > Subject: Re: [v4 PATCH 12/12] ARM: dts: add spi nodes for the atmel boards
> >
> > On 15:34 Mon 14 Jan     , Wenyou Yang wrote:
> > > From: Richard Genoud <richard.genoud@gmail.com>
> > >
> > > Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> > > [wenyou.yang@atmel.com: added spi nodes for the sam9263ek,
> sam9g20ek,
> > sam9m10g45ek and sam9n12ek boards]
> > > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > > Cc: linux@arm.linux.org.uk
> > > ---
> > >  arch/arm/boot/dts/at91sam9263ek.dts         |   14
> > ++++++++++++++
> > >  arch/arm/boot/dts/at91sam9g20ek_common.dtsi |   14
> > ++++++++++++++
> > >  arch/arm/boot/dts/at91sam9m10g45ek.dts      |   14
> > ++++++++++++++
> > >  arch/arm/boot/dts/at91sam9n12ek.dts         |   14
> > ++++++++++++++
> > >  arch/arm/boot/dts/at91sam9x5ek.dtsi         |   14
> ++++++++++++++
> > >  5 files changed, 70 insertions(+)
> > >
> > > diff --git a/arch/arm/boot/dts/at91sam9263ek.dts
> > b/arch/arm/boot/dts/at91sam9263ek.dts
> > > index 1eb0872..63ba57b 100644
> > > --- a/arch/arm/boot/dts/at91sam9263ek.dts
> > > +++ b/arch/arm/boot/dts/at91sam9263ek.dts
> > > @@ -79,6 +79,20 @@
> > >  					};
> > >  				};
> > >  			};
> > > +
> > > +			spi0: spi@fffa4000 {
> > > +				status = "okay";
> > > +				cs-gpios = <&pioA 5 0
> > > +					    &pioA 3 0
> > > +					    &pioA 4 0
> > > +					    &pioB 11 0
> > NACK
> >
> > we no use that much as cs-gpios on this hw
> 
> Thanks for your feedback.
> 
> Listing the all choices for cs-gpios, one cs-gpio is selected by reg value.
> Maybe listing one cs-gpio is OK.
> I will try it.
> 
> I am going to dig the feasibility of removing cs-gpios.

I need remain the list of cs-gpios, because "master->num_chipselect" is got from the number of item of this list.
If this list is removed, only the cs-gpio for used chip-select is provided , it works for CS0 chip-select, but it fails to work for other than CS0, e.g. CS1.

Could you give me some idea?
Thank you in advance.

> 
> > > +					   >;
> > > +				mtd_dataflash@0 {
> > > +					compatible = "atmel,at45", "atmel,dataflash";
> > > +					spi-max-frequency = <50000000>;
> > > +					reg = <0>;
> > > +				};
> > > +			};
> > >  		};
> > >
> > >  		nand0: nand@40000000 {
> > > diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
> > b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
> > > index da15e83..49ad49e 100644
> > > --- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
> > > +++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
> > > @@ -96,6 +96,20 @@
> > >  				status = "okay";
> > >  				pinctrl-0 = <&pinctrl_ssc0_tx>;
> > >  			};
> > > +
> > > +			spi0: spi@fffc8000 {
> > > +				status = "okay";
> > > +				cs-gpios = <&pioA 3 0
> > > +					    &pioC 11 0
> > > +					    &pioC 16 0
> > > +					    &pioC 17 0
> > ditto and so on
> >
> > you must only provife the gpio use by the hw
> > > +					   >;
> > > +				mtd_dataflash@0 {
> > > +					compatible = "atmel,at45", "atmel,dataflash";
> > > +					spi-max-frequency = <50000000>;
> > > +					reg = <1>;
> > > +				};
> > > +			};
> > >  		};
> > >
> > >  		nand0: nand@40000000 {
> > > diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts
> > b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> > > index 20c3191..275f22d 100644
> > > --- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
> > > +++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
> > > @@ -102,6 +102,20 @@
> > >  					};
> > >  				};
> > >  			};
> > > +
> > > +			spi0: spi@fffa4000{
> > > +				status = "okay";
> > > +				cs-gpios = <&pioB 3 0
> > > +					    &pioB 18 0
> > > +					    &pioB 19 0
> > > +					    &pioD 27 0
> > > +					   >;
> > > +				mtd_dataflash@0 {
> > > +					compatible = "atmel,at45", "atmel,dataflash";
> > > +					spi-max-frequency = <13000000>;
> > > +					reg = <0>;
> > > +				};
> > > +			};
> > >  		};
> > >
> > >  		nand0: nand@40000000 {
> > > diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts
> > b/arch/arm/boot/dts/at91sam9n12ek.dts
> > > index 0376bf4..4eeca7b 100644
> > > --- a/arch/arm/boot/dts/at91sam9n12ek.dts
> > > +++ b/arch/arm/boot/dts/at91sam9n12ek.dts
> > > @@ -67,6 +67,20 @@
> > >  					};
> > >  				};
> > >  			};
> > > +
> > > +			spi0: spi@f0000000 {
> > > +				status = "okay";
> > > +				cs-gpios = <&pioA 14 0
> > > +					    &pioA 7 0
> > > +					    &pioA 1 0
> > > +					    &pioB 3 0
> > > +					   >;
> > > +				m25p80@0 {
> > > +					compatible = "atmel,at25df321a";
> > > +					spi-max-frequency = <50000000>;
> > > +					reg = <0>;
> > > +				};
> > > +			};
> > >  		};
> > >
> > >  		nand0: nand@40000000 {
> > > diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> > b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> > > index 8a7cf1d..ca0a056 100644
> > > --- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> > > +++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> > > @@ -84,6 +84,20 @@
> > >  					};
> > >  				};
> > >  			};
> > > +
> > > +			spi0: spi@f0000000 {
> > > +				status = "okay";
> > > +				cs-gpios = <&pioA 14 0
> > > +					    &pioA 7 0
> > > +					    &pioA 1 0
> > > +					    &pioB 3 0
> > > +					   >;
> > > +				m25p80@0 {
> > > +					compatible = "atmel,at25df321a";
> > > +					spi-max-frequency = <50000000>;
> > > +					reg = <0>;
> > > +				};
> > > +			};
> > >  		};
> > >
> > >  		usb0: ohci@00600000 {
> > > --
> > > 1.7.9.5
> > >
> 
> Best Regards,
> Wenyou Yang

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
