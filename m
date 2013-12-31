Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3LaKzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:55:40 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:32944 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab3LaKzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:55:38 -0500
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Scott H Kilau <Scott_Kilau@digi.com>, Eng.Linux@digi.com,
        trivial@kernel.org
Subject: [PATCH linux-next 1/2] staging: dgap: fix missing header inclusion
Date: Tue, 31 Dec 2013 11:55:08 +0100
Message-Id: <1388487309-22319-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include slab.h to fix the following compilation error:

  drivers/staging/dgap/dgap_fep5.c: In function ‘dgap_do_config_load’:
  drivers/staging/dgap/dgap_fep5.c:78:2: error: implicit declaration of function ‘kzalloc’ [-Werror=implicit-function-declaration]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Lidza Louina <lidza.louina@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Scott H Kilau <Scott_Kilau@digi.com>
Cc: Eng.Linux@digi.com
Cc: trivial@kernel.org
---

Hi,

This can be seen with e.g. linux next-20131224 arm allmodconfig.

Best regards,

V.

 drivers/staging/dgap/dgap_fep5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgap/dgap_fep5.c b/drivers/staging/dgap/dgap_fep5.c
index 15f9a85..7deea2a 100644
--- a/drivers/staging/dgap/dgap_fep5.c
+++ b/drivers/staging/dgap/dgap_fep5.c
@@ -39,6 +39,7 @@
 #include <asm/uaccess.h>	/* For copy_from_user/copy_to_user */
 #include <linux/tty.h>
 #include <linux/tty_flip.h>	/* For tty_schedule_flip */
+#include <linux/slab.h>
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)
 #include <linux/sched.h>
-- 
1.8.5.2

