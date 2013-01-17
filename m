Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3AQCyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:54:37 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34776 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab3AQCyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:31 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 01/86] drivers/net/ethernet/fujitsu: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:52:53 -0800
Message-Id: <1358391258-1771-2-git-send-email-keescook@chromium.org>
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
 drivers/net/ethernet/fujitsu/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/fujitsu/Kconfig b/drivers/net/ethernet/fujitsu/Kconfig
index dffee9d..80926c1 100644
--- a/drivers/net/ethernet/fujitsu/Kconfig
+++ b/drivers/net/ethernet/fujitsu/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_FUJITSU
 	bool "Fujitsu devices"
 	default y
-	depends on ISA || PCMCIA || ((ISA || MCA_LEGACY) && EXPERIMENTAL)
+	depends on ISA || PCMCIA || MCA_LEGACY
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
@@ -18,8 +18,8 @@ config NET_VENDOR_FUJITSU
 if NET_VENDOR_FUJITSU
 
 config AT1700
-	tristate "AT1700/1720 support (EXPERIMENTAL)"
-	depends on (ISA || MCA_LEGACY) && EXPERIMENTAL
+	tristate "AT1700/1720 support"
+	depends on (ISA || MCA_LEGACY)
 	select CRC32
 	---help---
 	  If you have a network (Ethernet) card of this type, say Y and read
-- 
1.7.9.5

