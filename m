Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaLENzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:55:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53446 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaLENzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:55:49 -0500
Message-ID: <1417787724.3227.10.camel@pengutronix.de>
Subject: Re: [PATCH v18 0/12] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com
Date: Fri, 05 Dec 2014 14:55:24 +0100
In-Reply-To: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com>
References: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Am Freitag, den 05.12.2014, 14:22 +0800 schrieb Andy Yan:
> We found Freescale imx6 and Rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
> use the interface compatible Designware HDMI IP, but they also have some
> lightly differences, such as phy pll configuration, register width(imx hdmi
> register is one byte, but rk3288 is 4 bytes width and can only be accessed
> by word), 4K support(imx6 doesn't support 4k, but rk3288 does), and HDMI2.0
> support.
> 
> To reuse the imx-hdmi driver, we make this patch set:
> (1): fix some CodingStyle warning to make checkpatch happy
> (2): convert imx-hdmi to drm_bridge
> (3): split platform specific code
> (4): move imx-hdmi to bridge/dw_hdmi
> (5): extend dw_hdmi.c to support rk3288 hdmi
> (6): add rockchip rk3288 platform specific code dw_hdmi-rockchip.c
> 
> Changes in v18:
> - remove a multiple blank lines in imx-hdmi.c
> - fix a checkpatch warning in imx-hdmi_pltfm.c
> - add port bindings
> - correct some spelling mistakes in dw_hdmi bindings doc
> - correct some spelling mistakes in dw_hdmi-rockchip bindings doc
[...]

I am happy with the series so far. Pending Acks from the device tree
maintainers for the new binding documents, I'd like to apply either the
whole of it on top of
    git://git.pengutronix.de/git/pza/linux.git imx-drm/next
or take at least the i.MX specific patches (1-5) because of the
dependency on the imx-drm OF helper conversion.

regards
Philipp

