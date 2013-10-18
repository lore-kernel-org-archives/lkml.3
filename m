Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3JRWk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:40:56 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:50505 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3JRWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:40:55 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] thinkpad-acpi: Fix wrong assignment
Date: Fri, 18 Oct 2013 19:41:07 -0300
Message-Id: <1382136067-3888-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the thermal_init function when checking for thinkpad_id.ec_model,
the 'ta2' variable is being OR'd when acpi_ec_read call succeeds,
on fail it is setting 0 to 'ta1' variable instead.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 03ca6c1..ac6f938 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5730,7 +5730,7 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
 			if (acpi_ec_read(TP_EC_THERMAL_TMP8 + i, &t)) {
 				ta2 |= t;
 			} else {
-				ta1 = 0;
+				ta2 = 0;
 				break;
 			}
 		}
--
1.7.10.4

