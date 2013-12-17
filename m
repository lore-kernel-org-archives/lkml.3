Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab3LQSPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:15:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3LQSO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Gundersen <teg@jklm.no>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 055/103] Input: mousedev - allow disabling even without CONFIG_EXPERT
Date: Tue, 17 Dec 2013 18:12:44 +0000
Message-Id: <1387304012-23805-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Gundersen <teg@jklm.no>

commit dfaaed08ecc01bd513248ba7999daf50ce028352 upstream.

Moust (if not all) modern software, including X, uses /dev/eventX rather than
the legacy /dev/mouseX devices. It therefore makes sense for general-purpose
(distro) kernels to use MOUSEDV=m (or even n), so let's drop the EXPERT=y
requirement.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 55f7e57..98b6add 100644
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
1.8.3.2

