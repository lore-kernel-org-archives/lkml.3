Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3C3Oqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:46:38 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:61042 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3C3Oqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:46:37 -0400
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>
To: linux-kernel@vger.kernel.org
Subject: [RFC] gameport: limit the PDPI L4 driver to X86.
Date: Sat, 30 Mar 2013 15:46:26 +0100
Message-Id: <1364654786-18788-1-git-send-email-flameeyes@flameeyes.eu>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver, at least on ARM, can cause the kernel to fail with a
pointer dereference to address 0x210 (which it tries to outb to).

Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.eu>
---
 drivers/input/gameport/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/gameport/Kconfig b/drivers/input/gameport/Kconfig
index d279454..558cd5f 100644
--- a/drivers/input/gameport/Kconfig
+++ b/drivers/input/gameport/Kconfig
@@ -33,6 +33,7 @@ config GAMEPORT_NS558
 
 config GAMEPORT_L4
 	tristate "PDPI Lightning 4 gamecard support"
+	depend X86
 	help
 	  Say Y here if you have a PDPI Lightning 4 gamecard.
 
-- 
1.8.1.5

