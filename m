Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaLCJU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:20:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49466 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLCJUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:20:54 -0500
Message-ID: <1417598398.5124.2.camel@pengutronix.de>
Subject: Re: [PATCH v15 06/12] dt-bindings: add document for dw_hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Pawel Moll <pawel.moll@arm.com>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, rmk+kernel@arm.linux.org.uk,
        mark.yao@rock-chips.com, fabio.estevam@freescale.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, djkurtz@google.com,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        vladimir_zapolskiy@mentor.com, Lucas Stach <l.stach@pengutronix.de>
Date: Wed, 03 Dec 2014 10:19:58 +0100
In-Reply-To: <547E5F51.2090800@rock-chips.com>
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>
	 <1417506124-18626-1-git-send-email-andy.yan@rock-chips.com>
	 <1417544629.3411.15.camel@pengutronix.de> <547E5F51.2090800@rock-chips.com>
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

Am Mittwoch, den 03.12.2014, 08:54 +0800 schrieb Andy Yan:
> >> +Required properities:
> >> +- compatible: platform specific such as:
> >> +   * "fsl,imx6q-hdmi"
> >> +   * "fsl,imx6dl-hdmi"
> >> +   * "rockchip,rk3288-dw-hdmi"
> > I think we should add a common compatible value "snps,dw-hdmi-tx" here:
> >
> > 	compatible = "fsl,imx6q-hdmi", "snps,dw-hdmi-tx";
> >
>       How about "snps,dw-hdmi", because the driver is not only about
>    hdmi tx, but also include hdmi phy.

Synopsys call the whole module
"DesignWare HDMI Transmitter (TX) IP Solution":

https://www.synopsys.com/dw/ipdir.php?ds=dwc_hdmi_14_csds_tx
https://www.synopsys.com/dw/ipdir.php?ds=dwc_hdmi_20_csds_tx

That includes the PHY. I'd prefer keeping the -tx in there to
differentiate from a possible future "snps,dw-hdmi-rx":

https://www.synopsys.com/dw/ipdir.php?ds=dwc_hdmi_14_csds_rx
https://www.synopsys.com/dw/ipdir.php?ds=dwc_hdmi_20_csds_rx

>        If we add such compatible value, do we have to implement another
>     platform driver like dw_hdmi-pltfm.c with the 
> compatible="snps,dw-hdmi" ,
>     or just include the compatible value in dw_hdmi-imx.c and 
> dw_hdmi-rockchip.c?

That common compatible doesn't have to be used by any driver. It's just
there to show these are the same/similar IP core.
If a common driver without any SoC specific knowledge could be written,
that one would match against the common compatible.

regards
Philipp

