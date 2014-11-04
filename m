Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaKDO3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:29:53 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55583 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751228AbaKDO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:29:50 -0500
Date: Tue, 4 Nov 2014 14:29:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        djkurtz@google.com, ykk@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 0/2] make imx hdmi publicly used by dw hdmi compatible
 platform
Message-ID: <20141104142908.GG4042@n2100.arm.linux.org.uk>
References: <1415107992-34289-1-git-send-email-andy.yan@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415107992-34289-1-git-send-email-andy.yan@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:33:10PM +0800, Andy Yan wrote:
> From: Andy yan <andy.yan@rock-chips.com>
> 
> We found freescale imx6 and rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
> use the interface compatible Designware HDMI IP, but they also have some
> lightly difference, such as phy pll configuration, register width(imx hdmi
> register is one byte, but rk3288 is 4 bytes width and can only access by word),
> 4K support(imx6 doesn't support 4k, but rk3288 does).
> 
> To reuse the imx-hdmi driver, we do this patch set:
> patch (1): split out imx-soc code from imx-hdmi to dw_hdmi-imx.c
> patch (2): move imx-hdmi to bridge/, and rename to dw-hdmi to
> make this driver indepent of drm-imx . And we will add rockchip 
> platform specific code dw_hdmi-rockchip.c later, this is depend
> on drm-rockchip.

Great - I fully agree that this needs to be renamed as it is a Designware
IP.

Should it be moved into bridge/ ?  It isn't implemented as a DRM bridge
driver at present, so this seems illogical.  Is the longer term plan to
convert it to be a DRM bridge?

Secondly, if you want HDMI audio support, you may find the patches I
maintain for the SolidRun devices useful, which add this as a standard
ALSA device.  I also have CEC support for it as well.  If you're
interested, I'll email those.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
