Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab3IBJDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:03:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab3IBIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 41/58] ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text
Date: Mon,  2 Sep 2013 09:54:26 +0100
Message-Id: <1378112083-9475-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit ac124504ecf6b20a2457d873d0728a8b991a5b0c upstream.

Commit f6f91b0d9fd9 ("ARM: allow kuser helpers to be removed from the
vector page") introduced some help text for the CONFIG_KUSER_HELPERS
option which is rather contradictory.

Let's fix that, and improve it a little.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mm/Kconfig | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 8d194df..6c5a533 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -768,15 +768,18 @@ config KUSER_HELPERS
 	  the CPU type fitted to the system.  This permits binaries to be
 	  run on ARMv4 through to ARMv7 without modification.
 
+	  See Documentation/arm/kernel_user_helpers.txt for details.
+
 	  However, the fixed address nature of these helpers can be used
 	  by ROP (return orientated programming) authors when creating
 	  exploits.
 
 	  If all of the binaries and libraries which run on your platform
 	  are built specifically for your platform, and make no use of
-	  these helpers, then you can turn this option off.  However,
-	  when such an binary or library is run, it will receive a SIGILL
-	  signal, which will terminate the program.
+	  these helpers, then you can turn this option off to hinder
+	  such exploits. However, in that case, if a binary or library
+	  relying on those helpers is run, it will receive a SIGILL signal,
+	  which will terminate the program.
 
 	  Say N here only if you are absolutely certain that you do not
 	  need these helpers; otherwise, the safe option is to say Y.
-- 
1.8.3.2

