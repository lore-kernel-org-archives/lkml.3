Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaAHNsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:48:23 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37049 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbaAHNsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:48:21 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, angus.clark@st.com
Subject: [PATCH v4 00/36] mtd: st_spi_fsm: Add new driver
Date: Wed,  8 Jan 2014 13:46:43 +0000
Message-Id: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 4:
  Tended to Brian's previous review comments
    - Checkpatch acceptance
    - MODULE_DEVICE_TABLE() name slip correction
    - Timeout issue(s) resolved
    - Potential infinite loop mitigated
    - Code clarity suggests heeded
    - Duplication with MTD core code removed
    - Upgraded to using ROUND_UP() helper
    - Moved non-shared header code into main driver
    - Relocated dynamic msg sequence stores into main struct
    - Averted adaption of static (table) data
    - Basic whitespace/spelling/data type/dev_err suggestions accepted

Version 3:
  Okay, this thing should be fully functional now. Identify a chip
  based on it's JEDEC ID, Read, Write, Erase (all or by sector).
  Support for various chip quirks added too.
 
Version 2:
  The first bunch of these patches have been on the MLs before, but
  didn't receive a great deal of attention for the most part. We are
  a little more featureful this time however. We can now successfully
  setup and configure the N25Q256. We still can't read/write/erase
  it though. I'll start work on that next week and will provide it in
  the next instalment.
 
Version 1:
  First stab at getting this thing Mainlined. It doesn't do a great deal
  yet, but we are able to initialise the device and dynamically set it up
  correctly based on an extracted JEDEC ID.

 Documentation/devicetree/bindings/mtd/st-fsm.txt |   26 ++
 arch/arm/boot/dts/stih416-b2105.dts              |   14 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi           |   12 +
 drivers/mtd/devices/Kconfig                      |    8 +
 drivers/mtd/devices/Makefile                     |    1 +
 drivers/mtd/devices/serial_flash_cmds.h          |   81 ++++
 drivers/mtd/devices/st_spi_fsm.c                 | 2124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 2266 insertions(+)

