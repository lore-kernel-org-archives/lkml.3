Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab3BZOsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:48:11 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:34314 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842Ab3BZOsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:48:10 -0500
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, ldewangan@nvidia.com,
        sameo@linux.intel.com, Ian Lartey <ian@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH] mfd: palmas: is_palmas_charger needed by multiple drivers
Date: Tue, 26 Feb 2013 14:47:28 +0000
Message-Id: <1361890048-24555-1-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_palmas_charger checks for the presence of charging
functionality in the device

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
Acked-by: Laxman Dewangan<ldewangan@nvidia.com>
---
 include/linux/mfd/palmas.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 3129f9a..98c0567 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -26,6 +26,11 @@
 /* The ID_REVISION NUMBERS */
 #define PALMAS_CHIP_OLD_ID		0x0000
 #define PALMAS_CHIP_ID			0xC035
+#define PALMAS_CHIP_CHARGER_ID		0xC036
+
+#define is_palmas(a)	(((a) == PALMAS_CHIP_OLD_ID) || \
+			((a) == PALMAS_CHIP_ID))
+#define is_palmas_charger(a) ((a) == PALMAS_CHIP_CHARGER_ID)
 
 struct palmas_pmic;
 struct palmas_gpadc;
-- 
1.7.0.4

