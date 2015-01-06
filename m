Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbbAFLty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:49:54 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49796 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbbAFLtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:49:52 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Andy Yan <andy.yan@rock-chips.com>, Philipp Zabel <p.zabel@pengutronix.de>
Cc: airlied@linux.ie, fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk,
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
Subject: Re: [PATCH v18 0/12] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
Date: Tue, 06 Jan 2015 12:49:07 +0100
Message-ID: <1956639.ADgYrPHa6L@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <5481DDF2.6010700@rock-chips.com>
References: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com> <1417787724.3227.10.camel@pengutronix.de> <5481DDF2.6010700@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Am Samstag, 6. Dezember 2014, 00:31:46 schrieb Andy Yan:
> > I am happy with the series so far. Pending Acks from the device tree
> > maintainers for the new binding documents, I'd like to apply either the
> > whole of it on top of
> > 
> >      git://git.pengutronix.de/git/pza/linux.git imx-drm/next
> > 
> > or take at least the i.MX specific patches (1-5) because of the
> > dependency on the imx-drm OF helper conversion.

do you still want to take this series?

As for the devicetree ACK, there is this (unwritten) rule that if the
dt-maintainers do not respond after 3 weeks (and a ping mail to them)
it should be considered acked. As this version of the series is sitting
on the lists for a month now and nobody complained during the other
17 versions as well, I think we should be on the safe side :-)

There is one slight catch. Patch 3 needs a little modification, as the
THIS_MODULE ower of the imx_hdmi got meanwhile cleaned up.

So the patch would need to be modified as shown by the diff at the
bottom. I'm not sure if you want Andy to repost the whole series again
but I'll just post my fixed variant as reply to the origin v18 of patch 3
for convenience.


Heiko

-------------- 8< ----------------
--- "[PATCH v18 03_12] drm_imx_imx-hdmi_convert imx-hdmi to drm_bridge mode.mbox.old"	2015-01-06 12:33:52.000000000 +0100
+++ "[PATCH v18 03_12] drm_imx_imx-hdmi_convert imx-hdmi to drm_bridge mode.mbox"	2015-01-04 22:17:20.000000000 +0100
@@ -511,7 +511,7 @@
  {
  	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
  
-@@ -1723,42 +1682,17 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
+@@ -1723,41 +1682,17 @@ static void imx_hdmi_unbind(struct device *dev, struct device *master,
  	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
  
  	hdmi->connector.funcs->destroy(&hdmi->connector);
@@ -544,7 +544,6 @@
 -	.remove = imx_hdmi_platform_remove,
 -	.driver = {
 -		.name = "imx-hdmi",
--		.owner = THIS_MODULE,
 -		.of_match_table = imx_hdmi_dt_ids,
 -	},
 -};

