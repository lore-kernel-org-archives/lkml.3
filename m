Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbaLKLYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:24:50 -0500
Received: from gloria.sntech.de ([95.129.55.99]:60226 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbaLKLYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:24:49 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Kurtz <djkurtz@chromium.org>, David Airlie <airlied@linux.ie>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Andy Yan <andy.yan@rock-chips.com>, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        Yakir Yang <ykk@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devel@driverdev.osuosl.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Xu Jianqun <jay.xu@rock-chips.com>, Pawel Moll <pawel.moll@arm.com>,
        "mark.yao@rock-chips.com" <mark.yao@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com
Subject: Re: [PATCH v18 12/12] drm: bridge/dw_hdmi: add rockchip rk3288 support
Date: Thu, 11 Dec 2014 12:24:15 +0100
Message-ID: <6479148.dVz0vTNYfK@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <CAGS+omA1Gf8yqrd4Bu=Pm1OBdsJBHg0gt+TP_6vi88Zz+O3jHA@mail.gmail.com>
References: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com> <1417761259-17429-1-git-send-email-andy.yan@rock-chips.com> <CAGS+omA1Gf8yqrd4Bu=Pm1OBdsJBHg0gt+TP_6vi88Zz+O3jHA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Am Mittwoch, 10. Dezember 2014, 20:36:17 schrieb Daniel Kurtz:
> This driver adds HDMI to rockchip/drm.  The fact that rockchip's hdmi
> uses dw_hdmi is an implementation detail.  I do not think that the names
> used for rk3288-hdmi should include "dw" in them.
> 
> See inline for what I mean...

I guess in general this is more a matter of preference.

Past practices suggest that having the dw in the name is a sane solution too, 
like in dw_mmc-foo (mmc/host), dwmac-foo (net/ethernet/stmicro/stmmac).

And personally I'd keep to this already established naming scheme ... i.e. not 
hiding the dw heritage.

And also it looks like other involved parties like Philipp and Russell seemed 
to be ok with the naming through the revisions till now.

[...]

> > +static enum drm_mode_status
> > +dw_hdmi_rockchip_mode_valid(struct drm_connector *connector,
> 
> Similarly, I would rename these function names to start with
> rockchip_hdmi (or maybe rk_hdmi for brevity).
> Especially the ones for the module & driver: (bind/unbind/probe/remove).

Please keep to one rk <-> rockchip style at least per subsystem. The core drm 
driver uses rockchip, so the hdmi driver should too (instead of rk).


Heiko
