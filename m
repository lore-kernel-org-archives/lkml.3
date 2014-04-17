Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161217AbaDQIWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:22:54 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:51744
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756394AbaDQIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:22:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432I853kzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Thu, 17 Apr 2014 16:22:34 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: Shawn Guo <shawn.guo@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer Module
 timer node.
Message-ID: <20140417082228.GA22160@dragon>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
 <20140416085953.GC11602@dragon>
 <6934b6e7d11f4eb6a8ec74542820d718@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6934b6e7d11f4eb6a8ec74542820d718@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 07:49:31AM +0000, Li.Xiubo@freescale.com wrote:
> > > +			ftm0: ftm@40038000 {
> > > +				compatible = "fsl,vf610-ftm-timer";
> > > +				reg = <0x40038000 0x2000>;
> > > +				interrupts = <0 42 IRQ_TYPE_LEVEL_HIGH>;
> > > +				clock-names = "ftm0", "ftm1",
> > > +					"ftm0_counter_en", "ftm1_counter_en";
> > > +				clocks = <&clks VF610_CLK_FTM0>,
> > > +					<&clks VF610_CLK_FTM1>,
> > > +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>,
> > > +					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
> > > +				status = "disabled";
> > 
> > For such completely internal block which has no pins route out on board,
> > we should probably just not have this "disabled" status line.
> > 
> 
> Well, from IEEE 1275, there defined a standard 'status' property indicating
> The operational status of one device. The 'status' property has four possible
> values: 'okay/ok', 'disabled', 'fail' and 'fail-xxx'.
> 
> If it is absent, that means the status of the device is unknown or okay.

Yes, missing 'disabled' status equals to a 'okay' status from Linux
implementation.  Then, the device is always available in device tree,
and Linux Kconfig option will control whether the driver for the device
is enabled.

> 
> If discard the status line here in vf610.dtsi, this device will be enabled
> as default though 'no pins route out' on the board, and actually there has
> pins route out on the board, as timer devices here we just not use it, but
> as PWM devices the pins will be used.
> 
> How about let the node disabled in vf610.dtsi, and then enable it in vf610-twr.dts
> if it will be used in TWR board... ?

Okay.  If there is some use cases that have board level configuration
like pin out, I'm fine with your existing code.

Shawn

