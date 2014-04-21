Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaDUFbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:31:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44392 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaDUFb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:31:29 -0400
From: Andy Gross <agross@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 0/4] Introduce drivers/soc and add QCOM GSBI driver
Date: Mon, 21 Apr 2014 00:30:40 -0500
Message-Id: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch in this set adds the drivers/soc directory and all the necessary
plumbing.  These changes were discussed at the kernel summit and also were
introduced in an earlier patch set from Santosh Shilimkar.

Reference the following set of patches:
https://lkml.org/lkml/2014/2/28/567

The remaining patches add the QCOM GSBI (General Serial Bus Interface) driver,
device tree binding information for both the GSBI and child node interaction,
and lastly a patch to fix the current MSM serial driver to work correctly with
the GSBI changes.

Before this patch series, serial drivers (UART, I2C, and SPI) were all directly
accessing the overarching mux control settings for the parent GSBI device.  This
leads to unfortunate interactions when you want a UART and I2C device which
share the same GSBI interface.  By moving the serial devices to child nodes of
the GSBI, we can get the right mode setting for the ports and keep the children
from accessing the GSBI directly.

Andy Gross (4):
  soc: Placeholder files for drivers/soc
  soc: qcom: Add GSBI driver
  soc: qcom: Add device tree binding for GSBI
  tty: serial: msm: Remove direct access to GSBI

 .../devicetree/bindings/soc/qcom/qcom,gsbi.txt     |   78 +++++++++++++++
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    4 +
 drivers/soc/Kconfig                                |    5 +
 drivers/soc/Makefile                               |    5 +
 drivers/soc/qcom/Kconfig                           |   11 +++
 drivers/soc/qcom/Makefile                          |    1 +
 drivers/soc/qcom/qcom_gsbi.c                       |  101 ++++++++++++++++++++
 drivers/tty/serial/msm_serial.c                    |   48 +---------
 drivers/tty/serial/msm_serial.h                    |    5 -
 10 files changed, 209 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,gsbi.txt
 create mode 100644 drivers/soc/Kconfig
 create mode 100644 drivers/soc/Makefile
 create mode 100644 drivers/soc/qcom/Kconfig
 create mode 100644 drivers/soc/qcom/Makefile
 create mode 100644 drivers/soc/qcom/qcom_gsbi.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

