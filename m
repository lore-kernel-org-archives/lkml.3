Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaCJOGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:06:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:56097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaCJOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:06:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Gang Zhao <gamerh2o@gmail.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: wireless: Kconfig: add missing dependency for airo_cs
Date: Mon, 10 Mar 2014 15:05:25 +0100
Message-ID: <1398887.G3HYkOfaVN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o6bkU2ZImrFzMsepg2ydzkSfEj7lZLhoDT/E/oAKFD/
 QknRfjQwmOQAGEgCffIE4K+ByVjHjXtCPLflggo3DTOsmIcTnW
 Tecri+qVF3da8XtjqaOfbYiy2VGu8N968zywNBw8WHMV4YTOA9
 pN8i+g3SejjKqNu1eqknxYsl8DzPflJ8+pvt7UwsBkoWMpvXsN
 8w7vpL37GQBGL87/lAfn82QVEM+pNZ9SmmuKqwYXtHBQRJcy9m
 wlQJajhm0zVsOQLnH9hU8tv9R7RbK1iH3cfEjRu7AAOwfGS+/l
 wad42dG4mgQGGS8iYr/0iB5+JMZ2BLjwiA/eER44EPRCSxeoNI
 ezN/JV3CI4umThMahUv8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4c59ff221e070 "wireless: Kconfig: add missing dependency" added a number
of 'depends on CFG80211' statements, but missed the AIRO_CS driver that
also causes the airo.c file to be built. This adds the (hopefully) last
such missing statement
    
Cc: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index d1fab43..9c2c285 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -116,7 +116,7 @@ config AT76C50X_USB
 
 config AIRO_CS
 	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
-	depends on PCMCIA && (BROKEN || !M32R)
+	depends on CFG80211 && PCMCIA && (BROKEN || !M32R)
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
