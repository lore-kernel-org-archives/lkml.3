Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3AYUOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:14:06 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:43656 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3AYUOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:14:02 -0500
Date: Fri, 25 Jan 2013 12:13:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] sysfs: Fix build when sysfs is disabled
In-Reply-To: <1511541.AH8DLsNQJH@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.00.1301251211410.3815@chino.kir.corp.google.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <2760421.6nE3tkh92K@vostro.rjw.lan> <1551140.kO91IOVbjI@vostro.rjw.lan> <1511541.AH8DLsNQJH@vostro.rjw.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"sysfs: Functions for adding/removing symlinks to/from attribute groups" 
causes a build failure when CONFIG_SYSFS is disabled:

drivers/acpi/power.c: In function 'acpi_power_hide_list':
drivers/acpi/power.c:463: error: implicit declaration of function 'sysfs_remove_link_from_group'
drivers/acpi/power.c: In function 'acpi_power_expose_list':
drivers/acpi/power.c:486: error: implicit declaration of function 'sysfs_add_link_to_group'

We need to define empty functions for this config to avoid ifdefs in the 
code.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/sysfs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -330,6 +330,18 @@ static inline void sysfs_unmerge_group(struct kobject *kobj,
 {
 }
 
+static inline int sysfs_add_link_to_group(struct kobject *kobj,
+		const char *group_name, struct kobject *target,
+		const char *link_name)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_link_from_group(struct kobject *kobj,
+		const char *group_name, const char *link_name)
+{
+}
+
 static inline void sysfs_notify(struct kobject *kobj, const char *dir,
 				const char *attr)
 {
