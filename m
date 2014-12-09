Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaLIUVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:21:44 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:33640 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaLIUVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:21:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, broonie@kernel.org,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v4 0/2] spi: st: New driver for ST's SPI Controller
Date: Tue,  9 Dec 2014 20:21:29 +0000
Message-Id: <1418156491-26613-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new driver which controls the SPI component of ST's
Synchronous Serial Controller (SSC).

v3 => v4:
- Implicitly include Pinctrl header (build fails on foreign architectures)

v2 => v3:
- Fixes Patrice's review comments
- Removed COMPILE_TEST (at least until Will Deacon's patch lands)

v1 => v2:
- New, more specific CONFIG symbol
- Increased Runtime PM functionality
- Make use of new Pinctrl API
- Convert from SPI Bitbang => Transfer One
- Omit functionality which Core can handle
- Removal of *cough* debug code

Lee Jones (2):
  spi: Add new driver for STMicroelectronics' SPI Controller
  spi: st: Provide Device Tree binding documentation

 Documentation/devicetree/bindings/spi/spi-st.txt |  40 ++
 drivers/spi/Kconfig                              |   7 +
 drivers/spi/Makefile                             |   1 +
 drivers/spi/spi-st-ssc4.c                        | 510 +++++++++++++++++++++++
 4 files changed, 558 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-st.txt
 create mode 100644 drivers/spi/spi-st-ssc4.c

-- 
1.9.1

