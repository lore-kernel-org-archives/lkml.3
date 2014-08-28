Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaH1V3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:29:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35905 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaH1V3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:29:37 -0400
Message-ID: <53FF9E93.3040601@ti.com>
Date: Thu, 28 Aug 2014 17:26:43 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
CC: Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <swarren@nvidia.com>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <pdeschrijver@nvidia.com>, <agross@codeaurora.org>,
        <lgirdwood@gmail.com>, <robh+dt@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sandeep_n@ti.com>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <treding@nvidia.com>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 0/2] IO voltage domain support for rk3188 and rk3288
References: <1409254565-10677-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1409254565-10677-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2014 03:36 PM, Doug Anderson wrote:
> These two patches add support for automatically configuring the IO
> voltage domains on rk3188 and rk3288 SoCs.  The first patch adds some
> new notification types to the regulator code.  It's used by the second
> patch which actually implements the IO voltage domain driver.
> 
> These two patches were co-developed by Heiko Stübner and Doug Anderson
> (proof of concept patches were written by Heiko).  They were tested in
> a private branch on an rk3288 board using rk808 instead of mainline
> since rk808 support isn't finalized in mainline yet.
> 
> (sorry if you got this series twice; my mailer seems unhappy with me)
> 
> Heiko Stübner (2):
>   regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
>   soc/rockchip: io-domain: add driver handling io domains
> 
Sorry to shot down but your IO domains are nothing but voltage domains
and you should really build something in the drivers/power/*

Please have a look at the RFC [1]. You should really go on those
lines and collaborate to make a generic voltage domain layer instead of throwing
the driver under drivers/soc. 

>  .../devicetree/bindings/arm/rockchip/io-domain.txt |  60 ++++
>  drivers/regulator/core.c                           |  63 +++-
>  drivers/soc/Kconfig                                |   1 +
>  drivers/soc/Makefile                               |   1 +
>  drivers/soc/rockchip/Kconfig                       |  10 +
>  drivers/soc/rockchip/Makefile                      |   1 +
>  drivers/soc/rockchip/io-domain.c                   | 333 +++++++++++++++++++++
>  include/linux/regulator/consumer.h                 |  20 ++
>  8 files changed, 482 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/rockchip/io-domain.txt
>  create mode 100644 drivers/soc/rockchip/Kconfig
>  create mode 100644 drivers/soc/rockchip/Makefile
>  create mode 100644 drivers/soc/rockchip/io-domain.c
> 

Regards,
Santosh
[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/233819.html
