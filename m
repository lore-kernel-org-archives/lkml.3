Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab3CQNqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 09:46:36 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59511 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3CQNqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 09:46:33 -0400
From: Alexandre Courbot <gnurou@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 3/3] blackfin: force use of gpiolib
Date: Sun, 17 Mar 2013 22:42:03 +0900
Message-Id: <1363527723-32713-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1363527723-32713-1-git-send-email-acourbot@nvidia.com>
References: <1363527723-32713-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the GENERIC_GPIO option to false by default and force the use of
gpiolib instead of making it optional, to prepare for the removal of
GENERIC_GPIO.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/blackfin/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index c3f2e0b..20e203a 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -31,7 +31,7 @@ config BLACKFIN
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_CUSTOM_GPIO_H
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_UID16
 	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
@@ -56,7 +56,7 @@ config ZONE_DMA
 	def_bool y
 
 config GENERIC_GPIO
-	def_bool y
+	def_bool n
 
 config FORCE_MAX_ZONEORDER
 	int
-- 
1.8.2

