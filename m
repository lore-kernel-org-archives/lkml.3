Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaLCBep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:34:45 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59788 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751110AbaLCBen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:34:43 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] i2c-hid / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Wed, 03 Dec 2014 02:56:07 +0100
Message-ID: <3331107.SjqxFqQlza@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
depending on CONFIG_PM_RUNTIME may now be changed to depend on
CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/hid/i2c-hid/i2c-hid.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/hid/i2c-hid/i2c-hid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/hid/i2c-hid/i2c-hid.c
===================================================================
--- linux-pm.orig/drivers/hid/i2c-hid/i2c-hid.c
+++ linux-pm/drivers/hid/i2c-hid/i2c-hid.c
@@ -1095,7 +1095,7 @@ static int i2c_hid_resume(struct device
 }
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int i2c_hid_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);

