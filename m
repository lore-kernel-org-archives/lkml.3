Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967563AbaFTNwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:52:38 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:62975 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967461AbaFTNwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:52:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/3] thunderbolt: add PCI dependency
Date: Fri, 20 Jun 2014 15:52:09 +0200
Message-Id: <1403272331-3790755-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:jVlsahH24k/3TJPVI1MdcaaGAsJP8TbZckGMo3kdRCl
 wnva8GF1ZKPSjK/DHV5CXrBlbG0zn71Di0E8UnGVy1I/mgG8mK
 J5qw6vRzc1vMmVaeKkrxsZSq1y55pgKSNbuRVSk5bWwEufuH5U
 C5Joevpg0CjrPjlF/eqoT4Q9Oz1qV3+nbFlu5rBC37AHHUKTAZ
 ydY2pLGakFyVjygthmH3h7BFcqukztLh0Nnjm0RhfAeKJ+aelV
 2s92Ttt7QmdUaU3bT7FXTIrFZr2zFSE0cZZYvsQPQaA+fQ/UlR
 S5UuqKKgjgTlGyyHgEviwe//UcNdBBcNZGOHNW6VQw3/LDAv+6
 eJYCyMFyvfqttoic/7QHBMK9Zsq+ceM4YNi0cEiPj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thunderbolt drivers cannot be built if CONFIG_PCI is disabled,
better add an explicit Kconfig dependency.
The "default no" line is redundant and can be removed at the same
time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/thunderbolt/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
index 3a25529..5aab79b 100644
--- a/drivers/thunderbolt/Kconfig
+++ b/drivers/thunderbolt/Kconfig
@@ -1,6 +1,6 @@
 menuconfig THUNDERBOLT
 	tristate "Thunderbolt support for Apple devices"
-	default no
+	depends on PCI
 	help
 	  Cactus Ridge Thunderbolt Controller driver
 	  This driver is required if you want to hotplug Thunderbolt devices on
-- 
1.8.3.2

