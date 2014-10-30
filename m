Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbaJ3JDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:03:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43488 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbaJ3JDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:03:46 -0400
Message-ID: <1414659813.3069.3.camel@pengutronix.de>
Subject: Re: [RFC PATCH] mfd: syscon: add child device support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Date: Thu, 30 Oct 2014 10:03:33 +0100
In-Reply-To: <20140617142506.GA29841@lee--X1>
References: <1401198917-16077-1-git-send-email-p.zabel@pengutronix.de>
	 <20140617142506.GA29841@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Dienstag, den 17.06.2014, 15:25 +0100 schrieb Lee Jones:
> FAO DT chaps,
> 
> I'd be interested to hear your opinion about this.

any thoughts on this? With the MediaTek Reset Controller series
(https://lkml.org/lkml/2014/10/29/1008) another possible use case for
this feature came just up.

> > For devices which have a complete register for themselves, it is possible to
> > place them next to the syscon device with overlapping reg ranges. The same is
> > not possible for devices which only occupy bitfields in registers shared with
> > other users.
> > For devices that are completely controlled by bitfields in the syscon address
> > range, such as multiplexers or voltage regulators, allow to put child devices
> > into the syscon device node.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

> > ---
> >  Documentation/devicetree/bindings/mfd/syscon.txt | 11 +++++++++++
> >  drivers/mfd/syscon.c                             |  2 ++
> >  2 files changed, 13 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
> > index fe8150b..a7e11d5 100644
> > --- a/Documentation/devicetree/bindings/mfd/syscon.txt
> > +++ b/Documentation/devicetree/bindings/mfd/syscon.txt
> > @@ -9,10 +9,21 @@ using a specific compatible value), interrogate the node (or associated
> >  OS driver) to determine the location of the registers, and access the
> >  registers directly.
> >  
> > +Optionally, devices that are only controlled through single syscon
> > +registers or bitfields can also be added as child nodes to the syscon
> > +device node. These devices can implicitly assume their parent node
> > +as syscon provider without referencing it explicitly via phandle.
> > +In this case, the syscon node should have #address-cells = <1> and
> > +#size-cells = <0> and no ranges property.
> > +
> >  Required properties:
> >  - compatible: Should contain "syscon".
> >  - reg: the register region can be accessed from syscon
> >  
> > +Optional properties:
> > +- #address-cells: Should be 1.
> > +- #size-cells: Should be 0.
> > +
> >  Examples:
> >  gpr: iomuxc-gpr@020e0000 {
> >  	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> > diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> > index dbea55d..1dde475 100644
> > --- a/drivers/mfd/syscon.c
> > +++ b/drivers/mfd/syscon.c
> > @@ -147,6 +147,8 @@ static int syscon_probe(struct platform_device *pdev)
> >  
> >  	dev_dbg(dev, "regmap %pR registered\n", res);
> >  
> > +	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
> > +
> >  	return 0;
> >  }
> >  
> 


