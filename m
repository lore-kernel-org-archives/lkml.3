Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3FGIWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:22:51 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48175 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3FGIWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:22:48 -0400
From: Adam Lee <adam.lee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: [PATCH 3/3] thinkpad_acpi: add LED quirks of models which don't have EC controllable LEDs
Date: Fri,  7 Jun 2013 16:20:09 +0800
Message-Id: <1370593209-21358-4-git-send-email-adam.lee@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some new Lenovo or ThinkPad laptops don't have EC controllable LEDs.
This patch adds their quirks.

Signed-off-by: Adam Lee <adam.lee@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2fb1f1c..4cc7d73 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5268,6 +5268,12 @@ static const struct tpacpi_quirk led_useful_qtable[] __initconst = {
 	TPACPI_Q_IBM('7', 'F', 0x1f97), /* Z61* (1) */
 	TPACPI_Q_IBM('7', 'B', 0x1fb7), /* X60 (1) */
 
+	/* Models don't have EC controllable LEDs */
+	TPACPI_Q_LNV('G', 'D', 0), /* ThinkPad Twist */
+	TPACPI_Q_LNV('H', '0', 0), /* ThinkPad E430 */
+	TPACPI_Q_LNV('H', 'C', 0), /* Lenovo E49L */
+	TPACPI_Q_LNV('H', 'D', 0), /* Lenovo K4350 */
+
 	/* (1) - may have excess leds enabled on MSB */
 
 	/* Defaults (order matters, keep last, don't reorder!) */
-- 
1.7.10.4

