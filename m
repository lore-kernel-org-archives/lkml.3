Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab3IIKK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:10:26 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:50078 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3IIKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:10:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: [PATCH v2 00/14] iio: ST clean-ups and new pressure sensor device
Date: Mon,  9 Sep 2013 11:09:56 +0100
Message-Id: <1378721410-30937-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set includes a few clean-ups surrounding error handling and
non-mandatory functionality along with regulator support and the addition
of a new pressure/temperature sensor (LPS001WP). Everything has been
tested with Device Tree.

v2:
 - Rebased onto Linux -next as requested by Jonathan
 - Reworked clean-up patch to address Jonathan's concerns
 - Added binding document (inc regulators)
 - Extended regulator support in the driver
 - Re-worked Data Ready pin handling

 Documentation/devicetree/bindings/iio/pressure/lps001wp.txt |  21 ++++++++
 arch/arm/boot/dts/ste-dbx5x0.dtsi                           |   5 --
 arch/arm/boot/dts/ste-snowball.dts                          |  10 ++++
 arch/arm/configs/u8500_defconfig                            |   4 ++
 drivers/iio/common/st_sensors/st_sensors_core.c             |  51 +++++++++++--------
 drivers/iio/pressure/st_pressure.h                          |   1 +
 drivers/iio/pressure/st_pressure_core.c                     | 300 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 drivers/iio/pressure/st_pressure_i2c.c                      |   1 +
 include/linux/iio/common/st_sensors.h                       |   6 +++
 9 files changed, 299 insertions(+), 100 deletions(-)

