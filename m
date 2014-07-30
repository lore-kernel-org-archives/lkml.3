Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaG3Bts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:49:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaG3Btp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, Mark Salter <msalter@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 20/29] parport: fix menu breakage
Date: Tue, 29 Jul 2014 18:48:55 -0700
Message-Id: <20140730014810.182534349@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/parport/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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


