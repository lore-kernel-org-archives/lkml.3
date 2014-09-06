Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaIFMyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 08:54:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIFMyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 08:54:49 -0400
Date: Sat, 6 Sep 2014 05:54:28 -0700
From: tip-bot for Mark Rustad <tipbot@zytor.com>
Message-ID: <tip-9ea029f12aab2fa3f2913e67d17cc24801ba694e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mark.d.rustad@intel.com, tglx@linutronix.de,
        jeffrey.t.kirsher@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mark.d.rustad@intel.com,
        jeffrey.t.kirsher@intel.com
In-Reply-To: <1409972149-26272-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1409972149-26272-1-git-send-email-jeffrey.t.kirsher@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/tty/serial/8250:
  Resolve missing-field-initializers warnings
Git-Commit-ID: 9ea029f12aab2fa3f2913e67d17cc24801ba694e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ea029f12aab2fa3f2913e67d17cc24801ba694e
Gitweb:     http://git.kernel.org/tip/9ea029f12aab2fa3f2913e67d17cc24801ba694e
Author:     Mark Rustad <mark.d.rustad@intel.com>
AuthorDate: Fri, 5 Sep 2014 19:55:49 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 6 Sep 2014 10:20:53 +0200

x86/tty/serial/8250: Resolve missing-field-initializers warnings

Resolve some missing-field-initializers warnings by using
designated initialization in the expansion of the
SERIAL_PORT_DFNS macro.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Link: http://lkml.kernel.org/r/1409972149-26272-1-git-send-email-jeffrey.t.kirsher@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/serial.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/serial.h b/arch/x86/include/asm/serial.h
index 628c801..03ece8e 100644
--- a/arch/x86/include/asm/serial.h
+++ b/arch/x86/include/asm/serial.h
@@ -21,9 +21,9 @@
 
 #define SERIAL_PORT_DFNS			\
 	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
+	{ .uart = 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS }, /* ttyS0 */	\
+	{ .uart = 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS }, /* ttyS1 */	\
+	{ .uart = 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS }, /* ttyS2 */	\
+	{ .uart = 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS }, /* ttyS3 */
 
 #endif /* _ASM_X86_SERIAL_H */
