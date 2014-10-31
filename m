Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbaJaKu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:50:27 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:56242 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbaJaKuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <1414719509.32208.9.camel@mhfsdcap03>
References: <1414561058-23803-1-git-send-email-xudong.chen@mediatek.com>
	<1414561058-23803-2-git-send-email-xudong.chen@mediatek.com>
	<CABuKBeKp211c87TRdFb2kB+Qs8WoSAsg+5h-CF7sy7k2gj8O2g@mail.gmail.com>
	<1414719509.32208.9.camel@mhfsdcap03>
Date: Fri, 31 Oct 2014 11:50:23 +0100
Message-ID: <CABuKBeKuDYDdHhbatCNREpeaGH=c0FBRiyqpaRmDjZAYTxoWCw@mail.gmail.com>
Subject: Re: [PATCH 1/3] dt-bindings: Add I2C bindings for mt65xx/mt81xx.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: xudong chen <xudong.chen@mediatek.com>
Cc: Mark Rutland <mark.rutland@arm.com>, arm@kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org, Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-31 2:38 GMT+01:00 xudong chen <xudong.chen@mediatek.com>:
> On Thu, 2014-10-30 at 13:38 +0100, Matthias Brugger wrote:
>> 2014-10-29 6:37 GMT+01:00 Xudong Chen <xudong.chen@mediatek.com>:
>> > Add devicetree bindings for Mediatek Soc I2C driver.
>> >
>> > Signed-off-by: Xudong Chen <xudong.chen@mediatek.com>
>> > ---
>> >  .../devicetree/bindings/i2c/i2c-mt6577.txt         | 37 ++++++++++++++++++++++
>> >  1 file changed, 37 insertions(+)
>> >  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
>> >
>> > diff --git a/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt b/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
>> > new file mode 100644
>> > index 0000000..b4012c8
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
>> > @@ -0,0 +1,37 @@
>> > +* Mediatek's I2C controller
>> > +
>> > +The Mediatek's I2C controller is used to interface with I2C devices.
>> > +
>> > +Required properties:
>> > +  - compatible: value should be either of the following.
>> > +      (a) "mtk,mt6577-i2c", for i2c compatible with mt6577 i2c.
>>
>> Looking on the datasheet of mt6577 it does not seem that this driver
>> is really compatible.
>> I was not able to find the PATH_DIR register neither in the datasheet
>> nor in the source code.
>>
> Hi,
>
> The PATH_DIR register named OFFSET_PATH_DIR(0x60) in the source code.
> Only MT8135 supports this feature, so it does not contained in mt6577
> datasheet.
> I will modify the comment.
>
>> > +      (b) "mtk,mt8127-i2c", for i2c compatible with mt8127 i2c.
>> > +      (c) "mtk,mt8135-i2c", for i2c compatible with mt8135 i2c.
>> > +  - reg: physical base address of the controller and dma base, length of memory mapped
>> > +    region.
>> > +  - interrupts: interrupt number to the cpu.
>> > +  - clock-div: the fixed value for frequency divider of clock source in i2c module.
>> > +    Each IC may be different.
>> > +  - clocks: clock name from clock manager
>> > +  - clock-names: clock name used in i2c driver probe
>> > +
>> > +Optional properties:
>> > +  - clock-frequency: Frequency in Hz of the bus when transfer, the default value is 100000.
>> > +  - mediatek,have-pmic: platform can control i2c form special pmic side.
>
> I will change this to:
>  - mediatek,have-pmic: platform can control i2c form special pmic side,
> only MT8135 supports this.
>
> Is this OK?

We need a multi function device driver for the I2C and the PMIC.
Please have a look on my comments in the other thread.

Thanks,
Matthias

>
>> > +  - mediatek,have-dcm: platform has DCM(hardware digital clock manager) property.
>> > +  - mediatek,use-push-pull: IO use push-pull mode.
>> > +
>> > +Example:
>> > +
>> > +       i2c0: i2c@1100d000 {
>> > +                       compatible = "mediatek,mt6577-i2c";
>> > +                       reg = <0x1100d000 0x70>,
>> > +                             <0x11000300 0x80>;
>> > +                       interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_LOW>;
>> > +                       clock-frequency = <100000>;
>> > +                       mediatek,have-pmic;
>> > +                       clock-div = <16>;
>> > +                       clocks = <&i2c0_ck>, <&ap_dma_ck>;
>> > +                       clock-names = "main", "dma";
>> > +       };
>> > +
>> > --
>> > 1.8.1.1.dirty
>> >
>>
>>
>>
>
>



-- 
motzblog.wordpress.com
