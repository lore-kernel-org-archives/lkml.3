Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbaFQOZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:25:30 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:52874 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaFQOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:25:28 -0400
Date: Tue, 17 Jun 2014 15:25:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [RFC PATCH] mfd: syscon: add child device support
Message-ID: <20140617142506.GA29841@lee--X1>
References: <1401198917-16077-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401198917-16077-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAO DT chaps,

I'd be interested to hear your opinion about this.

> For devices which have a complete register for themselves, it is possible to
> place them next to the syscon device with overlapping reg ranges. The same is
> not possible for devices which only occupy bitfields in registers shared with
> other users.
> For devices that are completely controlled by bitfields in the syscon address
> range, such as multiplexers or voltage regulators, allow to put child devices
> into the syscon device node.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/mfd/syscon.txt | 11 +++++++++++
>  drivers/mfd/syscon.c                             |  2 ++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
> index fe8150b..a7e11d5 100644
> --- a/Documentation/devicetree/bindings/mfd/syscon.txt
> +++ b/Documentation/devicetree/bindings/mfd/syscon.txt
> @@ -9,10 +9,21 @@ using a specific compatible value), interrogate the node (or associated
>  OS driver) to determine the location of the registers, and access the
>  registers directly.
>  
> +Optionally, devices that are only controlled through single syscon
> +registers or bitfields can also be added as child nodes to the syscon
> +device node. These devices can implicitly assume their parent node
> +as syscon provider without referencing it explicitly via phandle.
> +In this case, the syscon node should have #address-cells = <1> and
> +#size-cells = <0> and no ranges property.
> +
>  Required properties:
>  - compatible: Should contain "syscon".
>  - reg: the register region can be accessed from syscon
>  
> +Optional properties:
> +- #address-cells: Should be 1.
> +- #size-cells: Should be 0.
> +
>  Examples:
>  gpr: iomuxc-gpr@020e0000 {
>  	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index dbea55d..1dde475 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -147,6 +147,8 @@ static int syscon_probe(struct platform_device *pdev)
>  
>  	dev_dbg(dev, "regmap %pR registered\n", res);
>  
> +	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
> +
>  	return 0;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
