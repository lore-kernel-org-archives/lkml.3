Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab3A1FSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:18:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60353 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab3A1FR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:17:59 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob@landley.net" <rob@landley.net>,
        "AnilKumar, Chimata" <anilkumar@ti.com>, "hs@denx.de" <hs@denx.de>
Subject: RE: [PATCH 2/6] ARM: davinci: da850: add DT node for I2C0
Thread-Topic: [PATCH 2/6] ARM: davinci: da850: add DT node for I2C0
Thread-Index: AQHN+ibBdwOkrc5fdUmgMhUirBj/bJhZgwCAgAS1ABA=
Date: Mon, 28 Jan 2013 05:17:28 +0000
Message-ID: <A4887BF146CD57468F700B415D2F4701581768@DBDE01.ent.ti.com>
References: <1359027324-14534-1-git-send-email-manishv.b@ti.com>
 <51026365.1020402@ti.com>
In-Reply-To: <51026365.1020402@ti.com>
Accept-Language: en-IN, en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0S5IDcd031975

On Fri, Jan 25, 2013 at 16:20:13, Nori, Sekhar wrote:
> On 1/24/2013 5:05 PM, Vishwanathrao Badarkhe, Manish wrote:
> > Add I2C0 device tree node information to da850-evm.
> > Also, add I2C0 pin muxing information in da850-evm.
> > 
> > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> > ---
> > Depends on patch
> > http://comments.gmane.org/gmane.linux.davinci/25993
> > 
> >  arch/arm/boot/dts/da850-evm.dts |   15 +++++++++++++++
> >  arch/arm/boot/dts/da850.dtsi    |   10 ++++++++++
> >  2 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/da850-evm.dts 
> > b/arch/arm/boot/dts/da850-evm.dts index 8cac9d2..3d8290a 100755
> > --- a/arch/arm/boot/dts/da850-evm.dts
> > +++ b/arch/arm/boot/dts/da850-evm.dts
> > @@ -27,5 +27,20 @@
> >  		serial2: serial@1d0d000 {
> >  			status = "okay";
> >  		};
> > +		i2c0@1c22000 {
> 
> This should be
> 		i2c0: i2c@1c22000
> 
> to follow the convention elsewhere in file.

Ok, I will change this in next version.

> 
> > +			status = "okay";
> > +		};
> > +	};
> > +};
> > +&pmx_core {
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <
> > +		&i2c0_pins
> > +	>;
> > +
> > +	i2c0_pins: pinmux_i2c0_pins{
> > +		pinctrl-single,bits = <
> > +			0x10 0x00002200 0x0000ff00	/* I2C0_SDA,I2C0_SCL */
> > +		>;
> 
> This should go into the dtsi file. See the discussion on NAND DT support submitted by Anil Kumar.

I have seen Anil Kumar's discussion for pin-muxing which includes Linus patch of grab pin 
control handles from device core at following location:
http://lkml.indiana.edu/hypermail/linux/kernel/1301.2/00094.html

I have done changes accordingly for I2C0 pin muxing and seen kernel crashes giving message 
like "i2c_davinci i2c_davinci.1: could not find pctldev for node /soc/
pinmux@1c14120/pinmux_i2c0_pins, deferring probe". This is happened because I2C0 driver 
gets probed before pin mux driver.
  
To resolve this issue, I made changes in code to ensure pin control driver gets probed before 
I2C0 driver by registering pin control driver during arch_init call.
 
Hence, in order to move I2C0 pin muxing in dtsi file above fix is required.
> 
> Thanks,
> Sekhar
> 
> PS: You are using an old address for Kevin Hilman. The MAINTAINERS file has been updated for a long time now. Liam's address is also wrong but I don't have his updated e-mail.
> 


Regards, 
Manish
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
