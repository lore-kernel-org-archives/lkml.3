Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3IKE6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3IKE4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:54 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=HenDe8a7tJgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=w11veCbKLq8A:10 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=X9qRLe6VJWi1FVvq:21 a=gmrQKNoplYEHaL_S:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042929.182484335@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [222/251] ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0222-ARM-7816-1-CONFIG_KUSER_HELPERS-fix-help-text.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

[ Upstream commit ac124504ecf6b20a2457d873d0728a8b991a5b0c ]

Commit f6f91b0d9fd9 ("ARM: allow kuser helpers to be removed from the
vector page") introduced some help text for the CONFIG_KUSER_HELPERS
option which is rather contradictory.

Let's fix that, and improve it a little.

Cc: <stable@vger.kernel.org>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mm/Kconfig |    9 ++++++---
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
1.7.10.4


