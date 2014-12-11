Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaLKSqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:46:15 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:63840 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaLKSqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:46:13 -0500
MIME-Version: 1.0
In-Reply-To: <1418291722-25448-3-git-send-email-lyz@rock-chips.com>
References: <1418291722-25448-1-git-send-email-lyz@rock-chips.com>
	<1418291722-25448-3-git-send-email-lyz@rock-chips.com>
Date: Thu, 11 Dec 2014 10:46:12 -0800
X-Google-Sender-Auth: QpbuQOycqDUm9lHQ8MrWIhtGenU
Message-ID: <CAD=FV=URDM5yH-t6kRvq=70v3OM=a7z6TesBrzqGZ9m-oxf+qg@mail.gmail.com>
Subject: Re: [PATCH v6 2/5] Documentation: bindings: add dt documentation for
 Rockchip usb PHY
From: Doug Anderson <dianders@chromium.org>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, jwerner@chromium.org,
        Olof Johansson <olof@lixom.net>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yunzhi,

On Thu, Dec 11, 2014 at 1:55 AM, Yunzhi Li <lyz@rock-chips.com> wrote:
> This patch adds a binding that describes the Rockchip usb PHYs
> found on Rockchip SoCs usb interface.

Technically the bindings patch is supposed to come before the driver.
So this should be patch #1 and the driver patch #2.


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

You don't have any sub nodes and are using the phy-cells.  Seems like
you should get rid of this?  ...or I guess switch to using sub nodes
and set "phy-cells" to 0?

> +
> +Optional Properties:
> +- clocks : phandle + clock specifier for the phy clocks

As per earlier, you should get rid of clocks.  If you really want a
clock here and it's optional:

* Back in the driver it shouldn't be a "warn".  You don't warn when
optional things are missing.

* You really should specify a clock name.  Right now this will pick
the first clock, which makes it hard to later add clocks.
