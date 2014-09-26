Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaIZKOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:14:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbaIZJqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 037/142] media: sms: Remove CONFIG_ prefix from Kconfig symbols
Date: Fri, 26 Sep 2014 11:44:08 +0200
Message-Id: <add15d1f45282a680d055ed219db2b28ae1933ba.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3c4b422adb7694418848cefc2a4669d63192c649 upstream.

X-Patchwork-Delegate: mchehab@redhat.com
Remove the CONFIG_ prefix from two Kconfig symbols in a dependency for
SMS_SIANO_DEBUGFS. This prefix is invalid inside Kconfig files.

Note that the current (common sense) dependency on SMS_USB_DRV and
SMS_SDIO_DRV being equal ensures that SMS_SIANO_DEBUGFS will not
violate its constraints. These constraint are that:
- it should only be built if SMS_USB_DRV is set;
- it can't be builtin if USB support is modular.

So drop the dependency on SMS_USB_DRV, as it is unneeded.

Fixes: 6c84b214284e ("[media] sms: fix randconfig building error")

Reported-by: Martin Walch <walch.martin@web.de>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/common/siano/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
index f953d33ee151..4bfbd5f463d1 100644
--- a/drivers/media/common/siano/Kconfig
+++ b/drivers/media/common/siano/Kconfig
@@ -22,8 +22,7 @@ config SMS_SIANO_DEBUGFS
 	bool "Enable debugfs for smsdvb"
 	depends on SMS_SIANO_MDTV
 	depends on DEBUG_FS
-	depends on SMS_USB_DRV
-	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV
+	depends on SMS_USB_DRV = SMS_SDIO_DRV
 
 	---help---
 	  Choose Y to enable visualizing a dump of the frontend
-- 
2.1.0

