Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaH2Njg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:39:36 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:40459 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaH2Nje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:39:34 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        olof@lixom.net
Cc: Addy Ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, swarren@nvidia.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, pdeschrijver@nvidia.com,
        agross@codeaurora.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        sandeep_n@ti.com, galak@codeaurora.org, grant.likely@linaro.org,
        treding@nvidia.com
Subject: [PATCH 0/2] IO voltage domain support for rk3188 and rk3288
Date: Thu, 28 Aug 2014 12:19:19 -0700
Message-Id: <1409253562-8907-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches add support for automatically configuring the IO
voltage domains on rk3188 and rk3288 SoCs.  The first patch adds some
new notification types to the regulator code.  It's used by the second
patch which actually implements the IO voltage domain driver.

These two patches were co-developed by Heiko Stübner and Doug Anderson
(proof of concept patches were written by Heiko).  They were tested in
a private branch on an rk3288 board using rk808 instead of mainline
since rk808 support isn't finalized in mainline yet.


Heiko Stübner (2):
  regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
  soc/rockchip: io-domain: add driver handling io domains

 .../devicetree/bindings/arm/rockchip/io-domain.txt |  60 ++++
 drivers/regulator/core.c                           |  63 +++-
 drivers/soc/Kconfig                                |   1 +
 drivers/soc/Makefile                               |   1 +
 drivers/soc/rockchip/Kconfig                       |  10 +
 drivers/soc/rockchip/Makefile                      |   1 +
 drivers/soc/rockchip/io-domain.c                   | 333 +++++++++++++++++++++
 include/linux/regulator/consumer.h                 |  20 ++
 8 files changed, 482 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/io-domain.txt
 create mode 100644 drivers/soc/rockchip/Kconfig
 create mode 100644 drivers/soc/rockchip/Makefile
 create mode 100644 drivers/soc/rockchip/io-domain.c

-- 
2.1.0.rc2.206.gedb03e5

