Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaBOCWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 21:22:19 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:42109 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751667AbaBOCWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 21:22:15 -0500
From: Ravi Patel <rapatel@apm.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jcm@redhat.com, patches@apm.com, Ravi Patel <rapatel@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Subject: [PATCH V3 0/4] mailbox: xgene: Add support for APM X-Gene SoC Queue Manager/Traffic Manager
Date: Fri, 14 Feb 2014 18:21:58 -0800
Message-Id: <1392430922-24643-1-git-send-email-rapatel@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
 QMTM is required by APM X-Gene SoC Ethernet, PktDMA (XOR Engine) and
 Security Engine subsystems. All subsystems communicate with QMTM using
 messages which include information about the work to be performed and
 the location of associated data buffers.

V3:
 * Switch to mailbox framework
 * Add support for little and big endian kernel
 * Change virt_to_phys function call to dma_zalloc_coherent

V2:
 * Adding COMPILE_TEST dependency for QMTM in Kconfig
 * Updated license banner as per review comments
 * Fixed alignment for macros
 * Changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL

V1:
 * inital version

Signed-off-by: Ravi Patel <rapatel@apm.com>
Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
---
Ravi Patel (4):
  Documentation: mailbox: APM X-Gene SoC QMTM
  Documentation: devicetree: bindings for APM X-Gene SoC QMTM
  mailbox: xgene: base driver for APM X-Gene SoC QMTM
  arm64: boot: dts: entries for APM X-Gene SoC QMTM

 .../devicetree/bindings/mailbox/apm-xgene-qmtm.txt |   53 ++
 Documentation/mailbox/apm-xgene-qmtm.txt           |  149 ++++++
 MAINTAINERS                                        |    9 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   18 +-
 drivers/mailbox/Kconfig                            |    2 +
 drivers/mailbox/Makefile                           |    1 +
 drivers/mailbox/xgene/Kconfig                      |    9 +
 drivers/mailbox/xgene/Makefile                     |    7 +
 drivers/mailbox/xgene/xgene_qmtm_main.c            |  516 ++++++++++++++++++++
 drivers/mailbox/xgene/xgene_qmtm_main.h            |  112 +++++
 drivers/mailbox/xgene/xgene_qmtm_storm.c           |  358 ++++++++++++++
 include/linux/platform_data/xgene_qmtm.h           |  300 ++++++++++++
 12 files changed, 1533 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/mailbox/apm-xgene-qmtm.txt
 create mode 100644 Documentation/mailbox/apm-xgene-qmtm.txt
 create mode 100644 drivers/mailbox/xgene/Kconfig
 create mode 100644 drivers/mailbox/xgene/Makefile
 create mode 100644 drivers/mailbox/xgene/xgene_qmtm_main.c
 create mode 100644 drivers/mailbox/xgene/xgene_qmtm_main.h
 create mode 100644 drivers/mailbox/xgene/xgene_qmtm_storm.c
 create mode 100644 include/linux/platform_data/xgene_qmtm.h

-- 
1.7.9.5

