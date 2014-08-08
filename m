Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaHHUn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:43:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40252 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106AbaHHUnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:43:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Randy Dunlap <rdunlap@infradead.org>, Mark Salter <msalter@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 176/259] parport: fix menu breakage
Date: Fri,  8 Aug 2014 13:39:59 -0700
Message-Id: <1407530482-4483-177-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit edffe1b626b39bd7121691dfdecb548431003bbb upstream.

Do not split the PARPORT-related symbols with the new kconfig
symbol ARCH_MIGHT_HAVE_PC_PARPORT. The split was causing incorrect
display of these symbols -- they were not being displayed together
as they should be.

Fixes: d90c3eb31535 "Kconfig cleanup (PARPORT_PC dependencies)"

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/parport/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 2872ece..44333bd 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -5,6 +5,12 @@
 # Parport configuration.
 #
 
+config ARCH_MIGHT_HAVE_PC_PARPORT
+	bool
+	help
+	  Select this config option from the architecture Kconfig if
+	  the architecture might have PC parallel port hardware.
+
 menuconfig PARPORT
 	tristate "Parallel port support"
 	depends on HAS_IOMEM
@@ -31,12 +37,6 @@ menuconfig PARPORT
 
 	  If unsure, say Y.
 
-config ARCH_MIGHT_HAVE_PC_PARPORT
-	bool
-	help
-	  Select this config option from the architecture Kconfig if
-	  the architecture might have PC parallel port hardware.
-
 if PARPORT
 
 config PARPORT_PC
-- 
1.9.1

