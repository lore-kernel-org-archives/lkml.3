Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbbA2Hac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:30:32 -0500
Received: from fallback4.mail.ru ([94.100.181.169]:34354 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbbA2Haa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:30:30 -0500
From: Andrey Danin <danindrey@mail.ru>
To: devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, ac100@lists.launchpad.net
Cc: Andrey Danin <danindrey@mail.ru>, Laxman Dewangan <ldewangan@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>
Subject: [PATCH 0/3] arm: tegra: implement NVEC driver using tegra i2c.
Date: Thu, 29 Jan 2015 10:20:19 +0300
Message-Id: <1422516022-27161-1-git-send-email-danindrey@mail.ru>
X-Mailer: git-send-email 1.9.1
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

NVEC driver contains code to manage tegra i2c controller in slave mode.
I2C slave support was implemented in linux kernel. The goal of this
patch serie is to implement I2C slave mode in tegra drived and rework
NVEC driver to use it.

Patches are based on i2c for-next.

Patch 1 imeplents slave mode for tegra I2C controller. This patch
was checked on tegra 2 device (Toshiba AC100) only. Please review
carefully.

Patch 2 reworks NVEC driver itself. I kept code close to original.

Patch 3 fixes device tree and documentation.


Thanks in advance

Andrey Danin (3):
  i2c: tegra: implement slave mode
  staging/nvec: reimplement on top of tegra i2c driver
  dt: paz00: define nvec as child of i2c bus

 .../devicetree/bindings/nvec/nvidia,nvec.txt       |  19 +-
 arch/arm/boot/dts/tegra20-paz00.dts                |  22 +-
 drivers/i2c/busses/i2c-tegra.c                     | 131 +++++++
 drivers/staging/nvec/nvec.c                        | 379 +++++++--------------
 drivers/staging/nvec/nvec.h                        |  17 +-
 5 files changed, 264 insertions(+), 304 deletions(-)

-- 
1.9.1

