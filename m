Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab3GDFld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:41:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:54402 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3GDFlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:41:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 2/4] power: make goldfish_battery depend on GOLDFISH || COMPILE_TEST
Date: Thu, 4 Jul 2013 01:39:11 -0400
Message-ID: <1372916353-24050-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly all the other goldfish peripherals (mtd, keyboard, etc)
have a dependency on the main platform's GOLDFISH Kconfig item,
but this one got skipped.  Even with consistency as a
justification, there was initial resistance[1] from some people
to adding it however, as they wanted the extra compile coverage.

Now, with CONFIG_COMPILE_TEST, we have the middle ground that
will give people the coverage who want it, and let those who
don't want it to skip ever seeing the option presented.

[1] https://lkml.org/lkml/2013/2/27/333

Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/power/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 7b8979c..dcc0d9e 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -357,7 +357,7 @@ config AB8500_BM
 
 config BATTERY_GOLDFISH
 	tristate "Goldfish battery driver"
-	depends on GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS && (GOLDFISH || COMPILE_TEST)
 	help
 	  Say Y to enable support for the battery and AC power in the
 	  Goldfish emulator.
-- 
1.8.1.2

