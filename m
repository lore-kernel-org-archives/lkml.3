Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaFKNXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:23:46 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:47322 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaFKNXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:23:44 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2014 09:23:44 EDT
From: Paul Chavent <Paul.Chavent@onera.fr>
To: giometti@enneenne.com, linux-kernel@vger.kernel.org
Cc: Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH] pps : disable kernel consumer support if HZ_IDLE.
Date: Wed, 11 Jun 2014 15:11:44 +0200
Message-Id: <1402492304-19647-1-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (briaree.onecert.fr [134.212.190.4]); Wed, 11 Jun 2014 15:13:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig already check if !NO_HZ, but miss if someone enables
NO_HZ_IDLE (which is equivalent).

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/pps/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 7512e98..c0d77ed 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -31,7 +31,7 @@ config PPS_DEBUG
 
 config NTP_PPS
 	bool "PPS kernel consumer support"
-	depends on !NO_HZ
+	depends on !NO_HZ && !NO_HZ_IDLE
 	help
 	  This option adds support for direct in-kernel time
 	  synchronization using an external PPS signal.
-- 
1.7.12.1

