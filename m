Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaEOUit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:38:49 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:65124 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbaEOUip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:38:45 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 2/6] watchdog: Document reboot API
Date: Thu, 15 May 2014 13:38:20 -0700
Message-Id: <1400186304-1691-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
References: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the new reboot API functionality.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Added documentation patch

 Documentation/watchdog/watchdog-kernel-api.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index a0438f3..39f8e00 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -90,6 +90,7 @@ struct watchdog_ops {
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	void (*reboot)(struct watchdog_device *);
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
 	unsigned int (*get_timeleft)(struct watchdog_device *);
@@ -148,6 +149,8 @@ they are supported. These optional routines/operations are:
   info structure).
 * status: this routine checks the status of the watchdog timer device. The
   status of the device is reported with watchdog WDIOF_* status flags/bits.
+* reboot: if this routine is present, it may be called to reboot the system.
+  Parameter is the pointer to the watchdog device.
 * set_timeout: this routine checks and changes the timeout of the watchdog
   timer device. It returns 0 on success, -EINVAL for "parameter out of range"
   and -EIO for "could not write value to the watchdog". On success this
@@ -224,3 +227,11 @@ the device tree (if the module timeout parameter is invalid). Best practice is
 to set the default timeout value as timeout value in the watchdog_device and
 then use this function to set the user "preferred" timeout value.
 This routine returns zero on success and a negative errno code for failure.
+
+The watchdog_do_reboot function can be used to reboot the system. This is
+intended to be used in systems which do not have an explicit reboot capability,
+but implement reboot by programming the watchdog to expire immediately. If
+the function is called, and a watchdog driver with reboot functionality was
+previously registered, the reboot function of that driver will be called.
+Architecture code should call watchdog_do_reboot from its machine_reboot
+function after other means to reboot the system failed.
-- 
1.9.1

