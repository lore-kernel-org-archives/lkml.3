Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbaKNKT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:19:58 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:27374 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935099AbaKNKT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:19:56 -0500
Message-ID: <5465D73C.9030507@imgtec.com>
Date: Fri, 14 Nov 2014 10:19:40 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
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
        <devicetree@vger.kernel.org>, <linux-rockchip@lists.infradead.org>,
        <jay.xu@rock-chips.com>, Pawel Moll <pawel.moll@arm.com>,
        <mark.yao@rock-chips.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v10 05/11] drm: bridge/dw_hdmi:split some phy configuration
 to platform driver
References: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com> <1415935631-16826-1-git-send-email-andy.yan@rock-chips.com>
In-Reply-To: <1415935631-16826-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Nice work on this patch series. Its getting better and better :).

On 14/11/14 03:27, Andy Yan wrote:
> hdmi phy clock symbol and transmission termination value
> can adjust platform specific to get the best SI

						^Is this signal integrity?

Are these two disjoint features in separate patches?

> 
> also add mode_valid interface for some platform may not support
> all the display mode

Sounds like another separate patch to me. :)

Also, This series is becoming quite large. With major changes and fixes mixed together.

Patch 3 splits imx-drm.
Patch 4 moves dw-drm out of imx-drm folder.
Patch 7 adds binding
Patch 9 converts to drm bridge.

Can these be placed together easily?
And in the start. i.e. patch 1, 2, 3, 4, 

Then all fixes etc can come afterwards?

It helps when checking histories later as to how a driver was made and how fixes happened.

Especially when file moves happen..

Cheers,
ZubairLK

> 
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> 
> ---
> 
> Changes in v10:
> - split generic dw_hdmi.c improvements from patch#11 (add rk3288 support)
> 
> Changes in v9: None
> Changes in v8: None
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/gpu/drm/bridge/dw_hdmi.c      | 29 +++++++++++++++++++++++++++--
>  drivers/staging/imx-drm/dw_hdmi-imx.c | 10 +++++++++-
>  include/drm/bridge/dw_hdmi.h          |  7 +++++++
>  3 files changed, 43 insertions(+), 3 deletions(-)
> 
