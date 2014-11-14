Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008AbaKNDNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:13:15 -0500
Received: from mailgw01.mediatek.com ([218.249.47.110]:51423 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933486AbaKNDNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:13:13 -0500
X-Listener-Flag: 11101
Message-ID: <1415934783.2152.59.camel@mhfsdcap03>
Subject: Re: [PATCH v2 1/3] dt-bindings: Add I2C bindings for mt65xx/mt81xx.
From: xudong chen <xudong.chen@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Grant Likely" <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, "Arnd Bergmann" <arnd@arndb.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        "Eddie Huang" <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Date: Fri, 14 Nov 2014 11:13:03 +0800
In-Reply-To: <20141113181649.GG1275@katana>
References: <1415078977-18374-1-git-send-email-xudong.chen@mediatek.com>
	 <1415078977-18374-2-git-send-email-xudong.chen@mediatek.com>
	 <20141113181649.GG1275@katana>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 19:16 +0100, Wolfram Sang wrote:
> On Tue, Nov 04, 2014 at 01:29:35PM +0800, Xudong Chen wrote:
> > Add devicetree bindings for Mediatek Soc I2C driver.
> > 
> > Signed-off-by: Xudong Chen <xudong.chen@mediatek.com>
> > ---
> >  .../devicetree/bindings/i2c/i2c-mt6577.txt         | 39 ++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt b/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
> > new file mode 100644
> > index 0000000..733e65e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
> > @@ -0,0 +1,39 @@
> > +* Mediatek's I2C controller
> > +
> > +The Mediatek's I2C controller is used to interface with I2C devices.
> > +
> > +Required properties:
> > +  - compatible: value should be either of the following.
> > +      (a) "mediatek,mt6577-i2c", for i2c compatible with mt6577 i2c.
> > +      (b) "mediatek,mt6589-i2c", for i2c compatible with mt6589 i2c.
> > +      (c) "mediatek,mt8127-i2c", for i2c compatible with mt8127 i2c.
> > +      (d) "mediatek,mt8135-i2c", for i2c compatible with mt8135 i2c.
> > +  - reg: physical base address of the controller and dma base, length of memory mapped
> > +    region.
> > +  - interrupts: interrupt number to the cpu.
> > +  - clock-div: the fixed value for frequency divider of clock source in i2c module.
> > +    Each IC may be different.
> 
> ? Doesn't that platform have CCF and can't we derive an I2C clock there?
> 
This value is fixed and is different from each chip. It cannot be get
from the CCF.

> > +  - clocks: clock name from clock manager
> > +  - clock-names: clock name used in i2c driver probe
> 
> This needs names of the clocks. Check other binding documentation for
> examples.
> 
OK I will add the names.
> > +Optional properties:
> > +  - clock-frequency: Frequency in Hz of the bus when transfer, the default value is 100000.
> > +  - mediatek,have-pmic: platform can control i2c form special pmic side.
> > +    Only mt6589 and mt8135 support this feature.
> > +  - mediatek,have-dcm: platform has DCM(hardware digital clock manager) property.
> > +  - mediatek,use-push-pull: IO use push-pull mode.
> 
> About the last 3 ones: Can't we encode this in the driver? Like, if the
> compatible is "mediatek,mt6589-i2c" we know it has this and that but not
> this?
> 
Yes, the DCM can be moved to the driver, but the pmic and push-pull
cannot encode in the driver.
Because Mediatek i2c IO-config compatible with open-drain and push-pull
mode, some devices use push-pull mode, so need set this in dts.
The PMIC feature can use the pins on PMIC(mt6397) side, if do not set
this the driver will use the I2C pins on the master chip.
I will try to explain more detail for PMIC in the other mail thread.

> > +
> > +Example:
> > +
> > +	i2c0: i2c@1100d000 {
> > +			compatible = "mediatek,mt6577-i2c";
> > +			reg = <0x1100d000 0x70>,
> > +			      <0x11000300 0x80>;
> > +			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_LOW>;
> > +			clock-frequency = <100000>;
> > +			mediatek,have-pmic;
> > +			clock-div = <16>;
> > +			clocks = <&i2c0_ck>, <&ap_dma_ck>;
> > +			clock-names = "main", "dma";
> > +	};
> > +
> > -- 
> > 1.8.1.1.dirty
> > 


