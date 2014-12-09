Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbaLIOmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:42:49 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:46104 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaLIOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:42:47 -0500
MIME-Version: 1.0
In-Reply-To: <1418093293-30557-1-git-send-email-lyz@rock-chips.com>
References: <1418093293-30557-1-git-send-email-lyz@rock-chips.com>
Date: Tue, 9 Dec 2014 15:42:46 +0100
Message-ID: <CABgxDo+XJGTdLtbKSeN38aOuVG-kizFs4a1o65HaeRAwKafGhw@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] Documentation: bindings: add doc for the Rockchip
 usb PHY
From: Romain Perier <romain.perier@gmail.com>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, "pawel.moll" <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-12-09 3:48 GMT+01:00 Yunzhi Li <lyz@rock-chips.com>:
> Document the bindings of the Rockchip usb PHY driver.


Long description is the same than the short one.. So either the long
description is useless
or it can be improved.

>
> +Required properties:
> + - compatible: rockchip,rk3288-usb-phy
> + - rockchip,grf : phandle to the syscon managing the "general
> +   register files"
> + - #phy-cells: should be 1
> + - #address-cells: should be 1
> + - #size-cells: should be 0
> +
> +Sub-nodes:
> +Each PHY should be represented as a sub-node.
> +
> +Sub-nodes
> +required properties:
> +- reg: the PHY number
> +               "0" - PHY connect to OTG controller
> +               "1" - PHY connect to HOST0 controller
> +               "2" - PHY connect to HOST1 controller
> +
> +Optional Properties:
> +- clocks : phandle + clock specifier for the phy clocks
> +
> +Example:
> +
> +usbphy: phy {
> +       #phy-cells = <1>;
> +       #address-cells = <1>;
> +       #size-cells = <0>;
> +       compatible = "rockchip,rk3288-usb-phy";
> +       rockchip,grf = <&grf>;
> +};

Could you reorder these properties to have the same order than in the
"required properties" ? Something like:

usbphy: phy {
       compatible = "rockchip,rk3288-usb-phy";
       rockchip,grf = <&grf>;
       #phy-cells = <1>;
       #address-cells = <1>;
       #size-cells = <0>;
};

Thanks,
Romain
