Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaLOSMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:12:24 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57929 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaLOSMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:12:21 -0500
MIME-Version: 1.0
In-Reply-To: <1418396866-32625-1-git-send-email-lyz@rock-chips.com>
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
	<1418396866-32625-1-git-send-email-lyz@rock-chips.com>
Date: Mon, 15 Dec 2014 10:12:20 -0800
X-Google-Sender-Auth: 8Z_lncjPU6XhfeaiyCpspaZYQBI
Message-ID: <CAD=FV=WvEcZAf-4yDBFVb3Bq8XLv=vWB5cM7GT9spOuYDLk96A@mail.gmail.com>
Subject: Re: [PATCH v7 2/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
From: Doug Anderson <dianders@chromium.org>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        jwerner@chromium.org, Olof Johansson <olof@lixom.net>,
        Tao Huang <huangtao@rock-chips.com>, Chris <zyw@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yunzhi,

On Fri, Dec 12, 2014 at 7:07 AM, Yunzhi Li <lyz@rock-chips.com> wrote:
> This patch to add a generic PHY driver for ROCKCHIP usb PHYs,
> currently this driver can support RK3288. The RK3288 SoC have
> three independent USB PHY IPs which are all configured through a
> set of registers located in the GRF (general register files)
> module.
>
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
>
> ---
>
> Changes in v7:
> - Accept Kishon's comments to use phandle args to find a phy
>   struct directly and get rid of using a custom of_xlate
>   function.
>
> Changes in v6:
> - Rename SIDDQ_MSK to SIDDQ_WRITE_ENA.
>
> Changes in v5: None
> Changes in v4:
> - Get number of PHYs from device tree.
> - Model each PHY as subnode of the phy provider node.
>
> Changes in v3:
> - Use BIT macro instead of bit shift ops.
> - Rename the config entry to PHY_ROCKCHIP_USB.
>
>  drivers/phy/Kconfig            |   7 ++
>  drivers/phy/Makefile           |   1 +
>  drivers/phy/phy-rockchip-usb.c | 158 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 166 insertions(+)
>  create mode 100644 drivers/phy/phy-rockchip-usb.c

On rk3288-pinky (on a 3.14 tree with backports), I can confirm that
this properly gets us into low power at suspend time.

Tested-by: Doug Anderson <dianders@chromium.org>
