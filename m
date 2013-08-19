Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897Ab3HSPPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:15:51 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55332 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3HSPPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:15:50 -0400
From: Jerome Meinke <jerome.meinke@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jerome Meinke <meinkej@informatik.uni-freiburg.de>
Subject: [PATCH 1/1] amilo-rfkill: Enable using amilo-rfkill with the FSC Amilo L1310.
Date: Mon, 19 Aug 2013 17:15:45 +0200
Message-Id: <1376925345-6687-1-git-send-email-meinkej@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change extends the amilo_rfkill_id_table[] with the DMI_BOARD_NAME information of the Amilo L1310, so that the wifi device can be switched on.

Signed-off-by: Jerome Meinke <meinkej@informatik.uni-freiburg.de>
---
 drivers/platform/x86/amilo-rfkill.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/amilo-rfkill.c b/drivers/platform/x86/amilo-rfkill.c
index 6296f07..da36b5e 100644
--- a/drivers/platform/x86/amilo-rfkill.c
+++ b/drivers/platform/x86/amilo-rfkill.c
@@ -85,6 +85,13 @@ static const struct dmi_system_id amilo_rfkill_id_table[] = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_BOARD_NAME, "AMILO L1310"),
+		},
+		.driver_data = (void *)&amilo_a1655_rfkill_ops
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
 			DMI_MATCH(DMI_BOARD_NAME, "AMILO M7440"),
 		},
 		.driver_data = (void *)&amilo_m7440_rfkill_ops
-- 
1.8.3.4

