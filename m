Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab3ICNk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:40:27 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63341 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3ICNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:40:23 -0400
From: Tom Gundersen <teg@jklm.no>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/2] input: allow MOUSEDEV=m even without EXPERT=y
Date: Tue,  3 Sep 2013 15:40:56 +0200
Message-Id: <1378215656-11827-2-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378215656-11827-1-git-send-email-teg@jklm.no>
References: <1378215656-11827-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moust (if not all) modern software, including X, uses /dev/eventX rather than
the legacy /dev/mouseX devices. It therefore makes sense for general-purpose
(distro) kernels to use MOUSEDV=m (or even n), so let's drop the EXPERT=y
requirement.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 38b523a..a11ff74 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -80,7 +80,7 @@ config INPUT_MATRIXKMAP
 comment "Userland interfaces"
 
 config INPUT_MOUSEDEV
-	tristate "Mouse interface" if EXPERT
+	tristate "Mouse interface"
 	default y
 	help
 	  Say Y here if you want your mouse to be accessible as char devices
-- 
1.8.4

