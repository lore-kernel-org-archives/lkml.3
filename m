Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3H0BK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:10:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab3H0BHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 47/74] ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text
Date: Mon, 26 Aug 2013 18:08:45 -0700
Message-Id: <20130827010434.392180682@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit ac124504ecf6b20a2457d873d0728a8b991a5b0c upstream.

Commit f6f91b0d9fd9 ("ARM: allow kuser helpers to be removed from the
vector page") introduced some help text for the CONFIG_KUSER_HELPERS
option which is rather contradictory.

Let's fix that, and improve it a little.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/Kconfig |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -789,15 +789,18 @@ config KUSER_HELPERS
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


