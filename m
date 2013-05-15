Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab3EOVEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:04:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41024 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab3EOVEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:04:20 -0400
Message-ID: <5193F827.8030809@infradead.org>
Date: Wed, 15 May 2013 14:03:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Platform Driver <platform-driver-x86@vger.kernel.org>
Subject: [PATCH -next] platform/x86: fix amilo-rfkill build errors
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
In-Reply-To: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build error in amilo-rfkill.c by making it dependent on
SERIO_I8042:

drivers/built-in.o: In function `amilo_a1655_rfkill_set_block':
amilo-rfkill.c:(.text+0x264a89): undefined reference to `i8042_lock_chip'
amilo-rfkill.c:(.text+0x264a97): undefined reference to `i8042_command'
amilo-rfkill.c:(.text+0x264a9e): undefined reference to `i8042_unlock_chip'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20130515.orig/drivers/platform/x86/Kconfig
+++ linux-next-20130515/drivers/platform/x86/Kconfig
@@ -175,7 +175,7 @@ config FUJITSU_TABLET
 
 config AMILO_RFKILL
 	tristate "Fujitsu-Siemens Amilo rfkill support"
-	depends on RFKILL
+	depends on RFKILL && SERIO_I8042
 	---help---
 	  This is a driver for enabling wifi on some Fujitsu-Siemens Amilo
 	  laptops.
