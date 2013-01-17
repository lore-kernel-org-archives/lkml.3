Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3AQDQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:16:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35341 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307Ab3AQCyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:32 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 10/86] drivers/net/ppp: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:02 -0800
Message-Id: <1358391258-1771-11-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ppp/Kconfig |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ppp/Kconfig b/drivers/net/ppp/Kconfig
index 872df3e..278dea0 100644
--- a/drivers/net/ppp/Kconfig
+++ b/drivers/net/ppp/Kconfig
@@ -82,8 +82,8 @@ config PPP_FILTER
 	  If unsure, say N.
 
 config PPP_MPPE
-	tristate "PPP MPPE compression (encryption) (EXPERIMENTAL)"
-	depends on PPP && EXPERIMENTAL
+	tristate "PPP MPPE compression (encryption)"
+	depends on PPP
 	select CRYPTO
 	select CRYPTO_SHA1
 	select CRYPTO_ARC4
@@ -96,8 +96,8 @@ config PPP_MPPE
 	  configuring PPTP clients and servers to utilize this method.
 
 config PPP_MULTILINK
-	bool "PPP multilink support (EXPERIMENTAL)"
-	depends on PPP && EXPERIMENTAL
+	bool "PPP multilink support"
+	depends on PPP
 	---help---
 	  PPP multilink is a protocol (defined in RFC 1990) which allows you
 	  to combine several (logical or physical) lines into one logical PPP
@@ -118,8 +118,8 @@ config PPPOATM
 	  changes its encapsulation unilaterally.
 
 config PPPOE
-	tristate "PPP over Ethernet (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PPP
+	tristate "PPP over Ethernet"
+	depends on PPP
 	---help---
 	  Support for PPP over Ethernet.
 
@@ -130,8 +130,8 @@ config PPPOE
 	  the heading "Kernel mode PPPoE").
 
 config PPTP
-	tristate "PPP over IPv4 (PPTP) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PPP && NET_IPGRE_DEMUX
+	tristate "PPP over IPv4 (PPTP)"
+	depends on PPP && NET_IPGRE_DEMUX
 	---help---
 	  Support for PPP over IPv4.(Point-to-Point Tunneling Protocol)
 
@@ -141,8 +141,8 @@ config PPTP
 	  utilize this module.
 
 config PPPOL2TP
-	tristate "PPP over L2TP (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && L2TP && PPP
+	tristate "PPP over L2TP"
+	depends on L2TP && PPP
 	---help---
 	  Support for PPP-over-L2TP socket family. L2TP is a protocol
 	  used by ISPs and enterprises to tunnel PPP traffic over UDP
-- 
1.7.9.5

