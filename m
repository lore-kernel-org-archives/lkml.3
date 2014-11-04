Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaKDOZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:25:46 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:19880 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaKDOZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:25:43 -0500
Message-ID: <5458E16F.7000501@imgtec.com>
Date: Tue, 4 Nov 2014 14:23:43 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, <djkurtz@google.com>,
        <ykk@rock-chips.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <devel@driverdev.osuosl.org>,
        <devicetree@vger.kernel.org>, <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH 1/2] imx-drm: imx-hdmi: split imx soc specific code from
 imx-hdmi
References: <1415107992-34289-1-git-send-email-andy.yan@rock-chips.com> <1415107992-34289-2-git-send-email-andy.yan@rock-chips.com>
In-Reply-To: <1415107992-34289-2-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,


On 04/11/14 13:33, Andy Yan wrote:
> imx6 and rockchip rk3288 and JZ4780 (Ingenic Xburst/MIPS)
> use the interface compatible Designware HDMI IP, but they
> also have some lightly difference, such as phy pll configuration,
> register width(imx hdmi register is one byte, but rk3288 is 4
> bytes width), 4K support(imx6 doesn't support 4k, but rk3288 does),
> clk useage,and the crtc mux configuration is also platform specific.
> 
> To reuse the imx hdmi driver, split the platform specific code out
> to dw_hdmi-imx.c.
> 
> Change-Id: I85e8d08754052b118423729a01c6d17bf485f383
> ---
>  drivers/staging/imx-drm/Makefile      |   2 +-
>  drivers/staging/imx-drm/dw_hdmi-imx.c | 214 ++++++++++
>  drivers/staging/imx-drm/imx-hdmi.c    | 726 ++++++++++++++--------------------
>  include/drm/bridge/dw_hdmi.h          | 114 ++++++
>  4 files changed, 634 insertions(+), 422 deletions(-)
>  create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
>  create mode 100644 include/drm/bridge/dw_hdmi.h
> 

This one patch does too much to be reviewed easily.

One patch is supposed to modify/add one thing at a time in the kernel.

Separating platform specific code from imx-drm/imx-hdmi is one thing.

Adding support for multi-byte register access is something different.

i.e. Something like.
1/3 split platform specific code out.
2/3 move/rename imx-hdmi outside the folder
3/3 add support for multi byte register width access.

If there are other things that are not directly relevant to the patch,
it goes in a different patch. Bug fixes are also separate.

This should result in readable patches that can be reviewed easily.

The maintainers might be able to guide on how to further split the patches if necessary.

Cheers,
ZubairLK
