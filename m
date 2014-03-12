Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaCLRzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:55:44 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:48059 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaCLRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:55:43 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v3 0/3] xtensa xtfpga SPI controller driver
Date: Wed, 12 Mar 2014 21:55:23 +0400
Message-Id: <1394646926-30496-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this series adds driver for SPI controller used on xtfpga xtensa platform,
device tree binding documentation and an entry to MAINTAINERS.

Changes v2 -> v3:
- support all transfer widths in the range 1...16 bit;
- don't swap bytes of 16 bit transfers.

Changes v1 -> v2:
- support 8 bit transfers;
- busy-wait for maximum 100 usec (instead of 100 msec) polling BUSY register;
- use chipselect callback to check transfer size.

Max Filippov (3):
  spi: add xtfpga SPI controller driver
  spi/xtensa-xtfpga: add DT binding documentation
  MAINTAINERS: add xtfpga platform section

 .../devicetree/bindings/spi/spi-xtensa-xtfpga.txt  |   9 ++
 MAINTAINERS                                        |   6 +
 drivers/spi/Kconfig                                |  13 ++
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-xtensa-xtfpga.c                    | 170 +++++++++++++++++++++
 5 files changed, 199 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga.txt
 create mode 100644 drivers/spi/spi-xtensa-xtfpga.c

-- 
1.8.1.4

