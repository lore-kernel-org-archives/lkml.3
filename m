Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500AbaKMRdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:33:19 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:63366 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbaKMRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <1415829690-20236-4-git-send-email-caesar.wang@rock-chips.com>
References: <1415829690-20236-1-git-send-email-caesar.wang@rock-chips.com>
	<1415829690-20236-4-git-send-email-caesar.wang@rock-chips.com>
Date: Thu, 13 Nov 2014 09:33:15 -0800
X-Google-Sender-Auth: 4SpiE9E_i2uYJhtpdXmKXRoK0bc
Message-ID: <CAD=FV=UKUnr33s85imePmcxizLK=AMYS8fPC7VvKnV4XXWFG2w@mail.gmail.com>
Subject: Re: [PATCH v11 3/3] ARM: dts: add rk3288 power-domain node
From: Doug Anderson <dianders@chromium.org>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        ZhenFu Fang <fzf@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 12, 2014 at 2:01 PM, Caesar Wang <caesar.wang@rock-chips.com> wrote:
> +               pd_vio {
> +                       reg = <RK3288_PD_VIO>;
> +                       clocks = <&cru ACLK_IEP>,
> +                                <&cru ACLK_ISP>,
> +                                <&cru ACLK_RGA_NIU>,
> +                                <&cru ACLK_RGA>,
> +                                <&cru ACLK_VIO0_NIU>,
> +                                <&cru ACLK_VIO1_NIU>,
> +                                <&cru ACLK_VIP>,
> +                                <&cru ACLK_VOP0>,
> +                                <&cru ACLK_VOP1>,
> +                                <&cru DCLK_VOP0>,
> +                                <&cru DCLK_VOP1>,
> +                                <&cru HCLK_IEP>,
> +                                <&cru HCLK_ISP>,
> +                                <&cru HCLK_RGA>,
> +                                <&cru HCLK_VIO_AHB_ARBI>,
> +                                <&cru HCLK_VIO_NIU>,
> +                                <&cru HCLK_VIO2_H2P>,
> +                                <&cru HCLK_VIP>,
> +                                <&cru HCLK_VOP0>,
> +                                <&cru HCLK_VOP1>,
> +                                <&cru PCLK_EDP_CTRL>,
> +                                <&cru PCLK_HDMI_CTRL>,
> +                                <&cru PCLK_LVDS_PHY>,
> +                                <&cru PCLK_MIPI_CSI>,
> +                                <&cru PCLK_MIPI_DSI0>,
> +                                <&cru PCLK_MIPI_DSI1>,
> +                                <&cru PCLK_VIO2_H2P>,
> +                                <&cru SCLK_EDP_24M>,
> +                                <&cru SCLK_EDP>,
> +                                <&cru SCLK_HDMI_CEC>,
> +                                <&cru SCLK_HDMI_HDCP>,
> +                                <&cru SCLK_ISP_JPE>,
> +                                <&cru SCLK_ISP>,
> +                                <&cru SCLK_RGA>;

This was discussed offlist, but just to make sure it's summarized here:

Some of the above clocks are "IGNORE_UNUSED" (AKA left on) in Linux
right now because nobody is managing them right now (due to the fact
that they are "interface unit clocks", etc).  The fact that these are
now being enabled and disabled as part of power domain transitions
will break this.

My vote would be to leave such clocks out of the list for now until we
figure out how they should be dealt with.


-Doug
