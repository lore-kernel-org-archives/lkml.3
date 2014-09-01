Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaIAPpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:45:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55573 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaIAPo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:44:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 7/8] staging: rtl8188eu: Hal8188EPwrSeq.h: fix lines over 80 char
Date: Mon,  1 Sep 2014 21:13:42 +0530
Message-Id: <1409586223-5915-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
References: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h |  411 ++++++++++++++------
 1 file changed, 288 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h b/drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h
index fabb201..43db92d 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h
@@ -47,130 +47,295 @@
 
     PWR SEQ Version: rtl8188E_PwrSeq_V09.h
 */
-#define	RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS	10
-#define	RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS	10
-#define	RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS	10
-#define	RTL8188E_TRANS_SUS_TO_CARDEMU_STEPS	10
-#define	RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS	10
-#define	RTL8188E_TRANS_PDN_TO_CARDEMU_STEPS	10
-#define	RTL8188E_TRANS_ACT_TO_LPS_STEPS		15
-#define	RTL8188E_TRANS_LPS_TO_ACT_STEPS		15
-#define	RTL8188E_TRANS_END_STEPS		1
-
-
-#define RTL8188E_TRANS_CARDEMU_TO_ACT														\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value }, comments here*/								\
-	{0x0006, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_POLLING, BIT1, BIT1},/* wait till 0x04[17] = 1    power ready*/	\
-	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT0|BIT1, 0}, /* 0x02[1:0] = 0	reset BB*/			\
-	{0x0026, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, BIT7}, /*0x24[23] = 2b'01 schmit trigger */	\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, 0}, /* 0x04[15] = 0 disable HWPDN (control by DRV)*/\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4|BIT3, 0}, /*0x04[12:11] = 2b'00 disable WL suspend*/	\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT0, BIT0}, /*0x04[8] = 1 polling until return 0*/	\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_POLLING, BIT0, 0}, /*wait till 0x04[8] = 0*/	\
-	{0x0023, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, 0}, /*LDO normal mode*/	\
-	{0x0074, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, BIT4}, /*SDIO Driving*/	\
-
-#define RTL8188E_TRANS_ACT_TO_CARDEMU													\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value }, comments here*/								\
-	{0x001F, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0},/*0x1F[7:0] = 0 turn off RF*/	\
-	{0x0023, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, BIT4}, /*LDO Sleep mode*/	\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT1, BIT1}, /*0x04[9] = 1 turn off MAC by HW state machine*/	\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_POLLING, BIT1, 0}, /*wait till 0x04[9] = 0 polling until return 0 to disable*/	\
-
-#define RTL8188E_TRANS_CARDEMU_TO_SUS													\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value }, comments here*/				\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, BIT3}, /*0x04[12:11] = 2b'01enable WL suspend*/	\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, BIT3|BIT4}, /*0x04[12:11] = 2b'11enable WL suspend for PCIe*/	\
-	{0x0007, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, BIT7}, /*  0x04[31:30] = 2b'10 enable enable bandgap mbias in suspend */	\
-	{0x0041, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, 0}, /*Clear SIC_EN register 0x40[12] = 1'b0 */	\
-	{0xfe10, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, BIT4}, /*Set USB suspend enable local register  0xfe10[4]=1 */	\
-	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_WRITE, BIT0, BIT0}, /*Set SDIO suspend local register*/	\
-	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT1, 0}, /*wait power state to suspend*/
-
-#define RTL8188E_TRANS_SUS_TO_CARDEMU													\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value }, comments here*/							\
-	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_WRITE, BIT0, 0}, /*Set SDIO suspend local register*/	\
-	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT1, BIT1}, /*wait power state to suspend*/\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, 0}, /*0x04[12:11] = 2b'01enable WL suspend*/
-
-#define RTL8188E_TRANS_CARDEMU_TO_CARDDIS													\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value },  comments here*/							\
-	{0x0026, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, BIT7}, /*0x24[23] = 2b'01 schmit trigger */	\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, BIT3}, /*0x04[12:11] = 2b'01 enable WL suspend*/	\
-	{0x0007, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0}, /*  0x04[31:30] = 2b'10 enable enable bandgap mbias in suspend */	\
-	{0x0041, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, 0}, /*Clear SIC_EN register 0x40[12] = 1'b0 */	\
-	{0xfe10, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, BIT4}, /*Set USB suspend enable local register  0xfe10[4]=1 */	\
-	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_WRITE, BIT0, BIT0}, /*Set SDIO suspend local register*/	\
-	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT1, 0}, /*wait power state to suspend*/
-
-#define RTL8188E_TRANS_CARDDIS_TO_CARDEMU													\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value }, comments here*/								\
-	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_WRITE, BIT0, 0}, /*Set SDIO suspend local register*/	\
-	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT1, BIT1}, /*wait power state to suspend*/\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, 0}, /*0x04[12:11] = 2b'01enable WL suspend*/
-
-#define RTL8188E_TRANS_CARDEMU_TO_PDN												\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value }, comments here*/							\
-	{0x0006, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT0, 0},/* 0x04[16] = 0*/\
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, BIT7},/* 0x04[15] = 1*/
-
-#define RTL8188E_TRANS_PDN_TO_CARDEMU												\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value },  comments here					 */ \
-	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, 0},/* 0x04[15] = 0*/
+#define RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS	10
+#define RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS	10
+#define RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS	10
+#define RTL8188E_TRANS_SUS_TO_CARDEMU_STEPS	10
+#define RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS	10
+#define RTL8188E_TRANS_PDN_TO_CARDEMU_STEPS	10
+#define RTL8188E_TRANS_ACT_TO_LPS_STEPS		15
+#define RTL8188E_TRANS_LPS_TO_ACT_STEPS		15
+#define RTL8188E_TRANS_END_STEPS		1
+
+
+#define RTL8188E_TRANS_CARDEMU_TO_ACT					\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value
+	 * },
+	 * comment here
+	 */								\
+	{0x0006, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_POLLING, BIT1, BIT1},			\
+	/* wait till 0x04[17] = 1    power ready*/	\
+	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT0|BIT1, 0},			\
+	/* 0x02[1:0] = 0	reset BB*/				\
+	{0x0026, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, BIT7},			\
+	/*0x24[23] = 2b'01 schmit trigger */				\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, 0},			\
+	/* 0x04[15] = 0 disable HWPDN (control by DRV)*/		\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4|BIT3, 0},			\
+	/*0x04[12:11] = 2b'00 disable WL suspend*/			\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT0, BIT0},			\
+	/*0x04[8] = 1 polling until return 0*/				\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_POLLING, BIT0, 0},			\
+	/*wait till 0x04[8] = 0*/					\
+	{0x0023, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, 0},			\
+	/*LDO normal mode*/						\
+	{0x0074, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, BIT4},			\
+	/*SDIO Driving*/
+
+#define RTL8188E_TRANS_ACT_TO_CARDEMU					\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value
+	 * },
+	 * comments here
+	 */								\
+	{0x001F, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0},			\
+	/*0x1F[7:0] = 0 turn off RF*/					\
+	{0x0023, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, BIT4},			\
+	/*LDO Sleep mode*/						\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT1, BIT1},			\
+	/*0x04[9] = 1 turn off MAC by HW state machine*/		\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_POLLING, BIT1, 0},			\
+	/*wait till 0x04[9] = 0 polling until return 0 to disable*/
+
+#define RTL8188E_TRANS_CARDEMU_TO_SUS					\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,			\
+	PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC,		\
+	PWR_CMD_WRITE, BIT3|BIT4, BIT3},				\
+	/* 0x04[12:11] = 2b'01enable WL suspend */			\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, BIT3|BIT4},		\
+	/* 0x04[12:11] = 2b'11enable WL suspend for PCIe */		\
+	{0x0007, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,			\
+	PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC,		\
+	PWR_CMD_WRITE, 0xFF, BIT7},					\
+	/* 0x04[31:30] = 2b'10 enable enable bandgap mbias in suspend */\
+	{0x0041, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,			\
+	PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC,		\
+	PWR_CMD_WRITE, BIT4, 0},					\
+	/*Clear SIC_EN register 0x40[12] = 1'b0 */			\
+	{0xfe10, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,			\
+	PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC,		\
+	PWR_CMD_WRITE, BIT4, BIT4},					\
+	/*Set USB suspend enable local register  0xfe10[4]=1 */		\
+	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_WRITE, BIT0, BIT0},			\
+	/*Set SDIO suspend local register*/				\
+	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT1, 0},			\
+	/*wait power state to suspend*/
+
+#define RTL8188E_TRANS_SUS_TO_CARDEMU					\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_WRITE, BIT0, 0},			\
+	/*Set SDIO suspend local register*/				\
+	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT1, BIT1},		\
+	/*wait power state to suspend*/					\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, 0},			\
+	/*0x04[12:11] = 2b'01enable WL suspend*/
+
+#define RTL8188E_TRANS_CARDEMU_TO_CARDDIS				\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0x0026, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, BIT7},			\
+	/*0x24[23] = 2b'01 schmit trigger */				\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,			\
+	PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC,		\
+	PWR_CMD_WRITE, BIT3|BIT4, BIT3},				\
+	/*0x04[12:11] = 2b'01 enable WL suspend*/			\
+	{0x0007, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,			\
+	PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC,		\
+	PWR_CMD_WRITE, 0xFF, 0},					\
+	/* 0x04[31:30] = 2b'10 enable enable bandgap mbias in suspend */\
+	{0x0041, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,			\
+	PWR_INTF_USB_MSK|PWR_INTF_SDIO_MSK, PWR_BASEADDR_MAC,		\
+	PWR_CMD_WRITE, BIT4, 0},					\
+	/*Clear SIC_EN register 0x40[12] = 1'b0 */			\
+	{0xfe10, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, BIT4},			\
+	/*Set USB suspend enable local register  0xfe10[4]=1 */		\
+	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_WRITE, BIT0, BIT0},			\
+	/*Set SDIO suspend local register*/				\
+	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT1, 0},			\
+	/*wait power state to suspend*/
+
+#define RTL8188E_TRANS_CARDDIS_TO_CARDEMU				\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_WRITE, BIT0, 0},			\
+	/*Set SDIO suspend local register*/				\
+	{0x0086, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_POLLING, BIT1, BIT1},		\
+	/*wait power state to suspend*/					\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT3|BIT4, 0},			\
+	/*0x04[12:11] = 2b'01enable WL suspend*/
+
+#define RTL8188E_TRANS_CARDEMU_TO_PDN					\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0x0006, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT0, 0},			\
+	/* 0x04[16] = 0*/						\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, BIT7},			\
+	/* 0x04[15] = 1*/
+
+#define RTL8188E_TRANS_PDN_TO_CARDEMU					\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0x0005, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT7, 0},			\
+	/* 0x04[15] = 0*/
 
 /* This is used by driver for LPSRadioOff Procedure, not for FW LPS Step */
-#define RTL8188E_TRANS_ACT_TO_LPS														\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value }, comments here				*/   \
-	{0x0522, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x7F},/*Tx Pause*/	\
-	{0x05F8, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_POLLING, 0xFF, 0},/*Should be zero if no packet is transmitting*/	\
-	{0x05F9, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_POLLING, 0xFF, 0},/*Should be zero if no packet is transmitting*/	\
-	{0x05FA, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_POLLING, 0xFF, 0},/*Should be zero if no packet is transmitting*/	\
-	{0x05FB, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_POLLING, 0xFF, 0},/*Should be zero if no packet is transmitting*/	\
-	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT0, 0},/*CCK and OFDM are disabled,and clock are gated*/	\
-	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_DELAY, 0, PWRSEQ_DELAY_US},/*Delay 1us*/	\
-	{0x0100, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x3F},/*Reset MAC TRX*/	\
-	{0x0101, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT1, 0},/*check if removed later*/	\
-	{0x0553, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT5, BIT5},/*Respond TxOK to scheduler*/	\
-
-
-#define RTL8188E_TRANS_LPS_TO_ACT															\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value }, comments here				 */ \
-	{0x0080, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK, PWR_BASEADDR_SDIO, PWR_CMD_WRITE, 0xFF, 0x84}, /*SDIO RPWM*/\
-	{0xFE58, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x84}, /*USB RPWM*/\
-	{0x0361, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x84}, /*PCIe RPWM*/\
-	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_DELAY, 0, PWRSEQ_DELAY_MS}, /*Delay*/\
-	{0x0008, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, 0}, /*.	0x08[4] = 0		 switch TSF to 40M*/\
-	{0x0109, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_POLLING, BIT7, 0}, /*Polling 0x109[7]=0  TSF in 40M*/\
-	{0x0029, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT6|BIT7, 0}, /*.	0x29[7:6] = 2b'00	 enable BB clock*/\
-	{0x0101, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT1, BIT1}, /*.	0x101[1] = 1*/\
-	{0x0100, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0xFF}, /*.	0x100[7:0] = 0xFF	 enable WMAC TRX*/\
-	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT1|BIT0, BIT1|BIT0}, /*.	0x02[1:0] = 2b'11	 enable BB macro*/\
-	{0x0522, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0}, /*.	0x522 = 0*/
-
-#define RTL8188E_TRANS_END															\
-	/* format */																\
-	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value },  comments here*/					\
-	{0xFFFF, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, 0, PWR_CMD_END, 0, 0}, /*  */
-
-
-extern struct wl_pwr_cfg rtl8188E_power_on_flow[RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS+RTL8188E_TRANS_END_STEPS];
-extern struct wl_pwr_cfg rtl8188E_radio_off_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS+RTL8188E_TRANS_END_STEPS];
-extern struct wl_pwr_cfg rtl8188E_card_disable_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS+RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS+RTL8188E_TRANS_END_STEPS];
-extern struct wl_pwr_cfg rtl8188E_card_enable_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS+RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS+RTL8188E_TRANS_END_STEPS];
-extern struct wl_pwr_cfg rtl8188E_suspend_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS+RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS+RTL8188E_TRANS_END_STEPS];
-extern struct wl_pwr_cfg rtl8188E_resume_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS+RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS+RTL8188E_TRANS_END_STEPS];
-extern struct wl_pwr_cfg rtl8188E_hwpdn_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS+RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS+RTL8188E_TRANS_END_STEPS];
-extern struct wl_pwr_cfg rtl8188E_enter_lps_flow[RTL8188E_TRANS_ACT_TO_LPS_STEPS+RTL8188E_TRANS_END_STEPS];
-extern struct wl_pwr_cfg rtl8188E_leave_lps_flow[RTL8188E_TRANS_LPS_TO_ACT_STEPS+RTL8188E_TRANS_END_STEPS];
+#define RTL8188E_TRANS_ACT_TO_LPS					\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0x0522, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x7F},/*Tx Pause*/	\
+	{0x05F8, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_POLLING, 0xFF, 0},			\
+	/*Should be zero if no packet is transmitting*/			\
+	{0x05F9, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_POLLING, 0xFF, 0},			\
+	/*Should be zero if no packet is transmitting*/			\
+	{0x05FA, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_POLLING, 0xFF, 0},			\
+	/*Should be zero if no packet is transmitting*/			\
+	{0x05FB, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_POLLING, 0xFF, 0},			\
+	/*Should be zero if no packet is transmitting*/			\
+	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT0, 0},			\
+	/*CCK and OFDM are disabled,and clock are gated*/		\
+	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_DELAY, 0,				\
+	PWRSEQ_DELAY_US},/*Delay 1us*/					\
+	{0x0100, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x3F},/*Reset MAC TRX*/	\
+	{0x0101, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT1, 0},/*check if removed later*/\
+	{0x0553, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT5, BIT5},			\
+	/*Respond TxOK to scheduler*/
+
+
+#define RTL8188E_TRANS_LPS_TO_ACT					\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0x0080, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_SDIO_MSK,	\
+	PWR_BASEADDR_SDIO, PWR_CMD_WRITE, 0xFF, 0x84}, /*SDIO RPWM*/	\
+	{0xFE58, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x84}, /*USB RPWM*/	\
+	{0x0361, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x84}, /*PCIe RPWM*/	\
+	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_DELAY, 0, PWRSEQ_DELAY_MS}, /*Delay*/	\
+	{0x0008, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT4, 0},			\
+	/* 0x08[4] = 0 switch TSF to 40M */				\
+	{0x0109, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_POLLING, BIT7, 0},			\
+	/* Polling 0x109[7]=0  TSF in 40M */				\
+	{0x0029, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT6|BIT7, 0},			\
+	/* 0x29[7:6] = 2b'00  enable BB clock */			\
+	{0x0101, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT1, BIT1},			\
+	/* 0x101[1] = 1 */						\
+	{0x0100, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0xFF},			\
+	/* 0x100[7:0] = 0xFF enable WMAC TRX */				\
+	{0x0002, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, BIT1|BIT0, BIT1|BIT0},		\
+	/* 0x02[1:0] = 2b'11 enable BB macro */				\
+	{0x0522, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,	\
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0}, /*.	0x522 = 0*/
+
+#define RTL8188E_TRANS_END						\
+	/* format
+	 * { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk,
+	 * value },
+	 * comments here
+	 */								\
+	{0xFFFF, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, 0,	\
+	PWR_CMD_END, 0, 0},
+
+
+extern struct wl_pwr_cfg rtl8188E_power_on_flow
+		[RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS + RTL8188E_TRANS_END_STEPS];
+extern struct wl_pwr_cfg rtl8188E_radio_off_flow
+		[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS + RTL8188E_TRANS_END_STEPS];
+extern struct wl_pwr_cfg rtl8188E_card_disable_flow
+		[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+		RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
+		RTL8188E_TRANS_END_STEPS];
+extern struct wl_pwr_cfg rtl8188E_card_enable_flow
+		[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+		RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
+		RTL8188E_TRANS_END_STEPS];
+extern struct wl_pwr_cfg rtl8188E_suspend_flow[
+		RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+		RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS +
+		RTL8188E_TRANS_END_STEPS];
+extern struct wl_pwr_cfg rtl8188E_resume_flow
+		[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+		RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS +
+		RTL8188E_TRANS_END_STEPS];
+extern struct wl_pwr_cfg rtl8188E_hwpdn_flow
+		[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+		RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS + RTL8188E_TRANS_END_STEPS];
+extern struct wl_pwr_cfg rtl8188E_enter_lps_flow
+		[RTL8188E_TRANS_ACT_TO_LPS_STEPS + RTL8188E_TRANS_END_STEPS];
+extern struct wl_pwr_cfg rtl8188E_leave_lps_flow
+		[RTL8188E_TRANS_LPS_TO_ACT_STEPS + RTL8188E_TRANS_END_STEPS];
 
 #endif /* __HAL8188EPWRSEQ_H__ */
-- 
1.7.10.4

