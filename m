Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab3FFM76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:59:58 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47124 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab3FFM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:59:56 -0400
From: =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] gameport: limit the configuration to x86 architecture.
Date: Thu,  6 Jun 2013 05:59:54 -0700
Message-Id: <1370523594-452117-1-git-send-email-flameeyes@flameeyes.eu>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gameport driver relies on features of x86/x86-64, so it's unlikely
that it could work on other architectures. Furthermore the l4 driver
can panic a kernel running on ARM (for instance) by trying to access
the 0x204 address.

Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.eu>
---
 drivers/input/gameport/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/gameport/Kconfig b/drivers/input/gameport/Kconfig
index d279454..611abed 100644
--- a/drivers/input/gameport/Kconfig
+++ b/drivers/input/gameport/Kconfig
@@ -3,6 +3,7 @@
 #
 config GAMEPORT
 	tristate "Gameport support"
+	depends on X86
 	---help---
 	  Gameport support is for the standard 15-pin PC gameport. If you
 	  have a joystick, gamepad, gameport card, a soundcard with a gameport
-- 
1.8.2.1

