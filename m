Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3JHUfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:35:55 -0400
Received: from sauhun.de ([89.238.76.85]:52197 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab3JHUfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:35:51 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: [PATCH 0/9] fix deferred probing issue of platform_driver_probe
Date: Tue,  8 Oct 2013 22:35:32 +0200
Message-Id: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had some issues with deferred probing in the I2C subsystem. This series
attempts to fix a part of it. From the patch description:

===

Subsystems like pinctrl and gpio rightfully make use of deferred probing at
core level. Now, deferred drivers won't be retried if they don't have a .probe
function specified in the driver struct. Fix this driver to have that, so the
devices it supports won't get lost in a deferred probe.

===

I think it makes sense to remove platform_driver_probe from bus masters like
i2c and spi (especially since they are dependant on pinctrl these days). This
is what this series does. I had a look at dma drivers as well, but there are
more things to be considered, so delayed for now.

Please comment. If no objections are raised, I'd like to bring at least the I2C
patches into v3.12, so deferred devices will then be correctly probed. The
series is based on 3.12-rc4 and was compile-tested. It is available at

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git platform_driver_probe_drop

Regards,

   Wolfram


Wolfram Sang (9):
  i2c: i2c-designware-platdrv: replace platform_driver_probe to support
    deferred probing
  i2c: i2c-imx: replace platform_driver_probe to support deferred
    probing
  i2c: i2c-mxs: replace platform_driver_probe to support deferred
    probing
  i2c: i2c-stu300: replace platform_driver_probe to support deferred
    probing
  spi: spi-au1550: replace platform_driver_probe to support deferred
    probing
  spi: spi-bfin5xx: replace platform_driver_probe to support deferred
    probing
  spi: spi-omap-uwire: replace platform_driver_probe to support deferred
    probing
  spi: spi-s3c64xx: replace platform_driver_probe to support deferred
    probing
  spi: spi-txx9: replace platform_driver_probe to support deferred
    probing

 drivers/i2c/busses/i2c-designware-platdrv.c |  5 +++--
 drivers/i2c/busses/i2c-imx.c                | 11 ++++++-----
 drivers/i2c/busses/i2c-mxs.c                |  3 ++-
 drivers/i2c/busses/i2c-stu300.c             | 11 +++++------
 drivers/spi/spi-au1550.c                    |  3 ++-
 drivers/spi/spi-bfin5xx.c                   |  5 +++--
 drivers/spi/spi-omap-uwire.c                |  5 +++--
 drivers/spi/spi-s3c64xx.c                   |  3 ++-
 drivers/spi/spi-txx9.c                      |  3 ++-
 9 files changed, 28 insertions(+), 21 deletions(-)

-- 
1.8.4.rc3

