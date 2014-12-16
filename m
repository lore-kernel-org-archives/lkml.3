Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaLPB7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:59:32 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:38197 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042AbaLPB7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:59:31 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH RESEND v2] mfd: syscon: add child device support
From: Flora Fu <flora.fu@mediatek.com>
To: Lee Jones <lee.jones@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>
CC: Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kernel@pengutronix.de>, Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
In-Reply-To: <20141215095819.GB7972@x1>
References: <1417451138-13583-1-git-send-email-p.zabel@pengutronix.de>
	 <1418636633.3193.3.camel@pengutronix.de>  <20141215095819.GB7972@x1>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Dec 2014 09:59:20 +0800
Message-ID: <1418695160.11847.7.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch set is used to implement reset controller in
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/299141.html

Tested-by: Flora Fu <flora.fu@mediatek.com>

Thanks,
Flora

On Mon, 2014-12-15 at 09:58 +0000, Lee Jones wrote:
> On Mon, 15 Dec 2014, Philipp Zabel wrote:
> > Am Montag, den 01.12.2014, 17:25 +0100 schrieb Philipp Zabel:
> > > For devices which have a complete register for themselves, it is possible to
> > > place them next to the syscon device with overlapping reg ranges. The same is
> > > not possible for devices which only occupy bitfields in registers shared with
> > > other users.
> > > For devices that are completely controlled by bitfields in the syscon address
> > > range, such as multiplexers or voltage regulators, allow to put child devices
> > > into the syscon device node.
> > 
> > What is the status of this patch?
> > Is this ok to be applied after the merge window closes?
> > 
> > For reference, these are the previous threads:
> > https://lkml.org/lkml/2014/5/27/422
> > https://lkml.org/lkml/2014/11/3/134
> 
> As this is such an important driver I need more Acks for users/testers
> and senior reviewers before applying.
> 
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > ---
> > > Changes since v1:
> > >  - Reworded binding documentation to allow #size-cells = <1>, which is useful
> > >    for syscon children that are controlled through a (possibly shared) register
> > >    range.
> > > ---
> > >  Documentation/devicetree/bindings/mfd/syscon.txt | 13 +++++++++++++
> > >  drivers/mfd/syscon.c                             |  3 +++
> > >  2 files changed, 16 insertions(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
> > > index fe8150b..0c6b497 100644
> > > --- a/Documentation/devicetree/bindings/mfd/syscon.txt
> > > +++ b/Documentation/devicetree/bindings/mfd/syscon.txt
> > > @@ -9,12 +9,25 @@ using a specific compatible value), interrogate the node (or associated
> > >  OS driver) to determine the location of the registers, and access the
> > >  registers directly.
> > >  
> > > +Optionally, devices that are controlled exclusively through syscon registers,
> > > +or even bitfields in shared syscon registers, can also be added as child nodes
> > > +to the syscon device node. These devices can implicitly assume their parent
> > > +node is a syscon provider without referencing it explicitly via phandle.
> > > +In this case, the syscon node should have #address-cells = <1> and
> > > +#size-cells = <0> or <1> and no ranges property.
> > > +
> > >  Required properties:
> > >  - compatible: Should contain "syscon".
> > >  - reg: the register region can be accessed from syscon
> > >  
> > > +Optional properties:
> > > +- #address-cells: Should be 1.
> > > +- #size-cells: Should be 0 or 1.
> > > +
> > >  Examples:
> > >  gpr: iomuxc-gpr@020e0000 {
> > > +	#address-cells = <1>;
> > > +	#size-cells = <0>;
> > >  	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> > >  	reg = <0x020e0000 0x38>;
> > >  };
> > > diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> > > index ca15878..38da178 100644
> > > --- a/drivers/mfd/syscon.c
> > > +++ b/drivers/mfd/syscon.c
> > > @@ -155,6 +155,9 @@ static int syscon_probe(struct platform_device *pdev)
> > >  
> > >  	dev_dbg(dev, "regmap %pR registered\n", res);
> > >  
> > > +	if (!of_device_is_compatible(pdev->dev.of_node, "simple-bus"))
> > > +		of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
> > > +
> > >  	return 0;
> > >  }
> > >  
> > 
> > 
> 


