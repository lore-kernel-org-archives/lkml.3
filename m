Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbaJDAPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:15:51 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55729 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaJCVpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:05 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com
Cc: teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, mcgrof@suse.com, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: [PATCH v2 3/7] driver-core: enable drivers to opt-out of async probe
Date: Fri,  3 Oct 2014 14:44:39 -0700
Message-Id: <1412372683-2003-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com>
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We'll soon add generic support for asynchronous probe, before
that gets merged lets let drivers annotate if they should never
probe asynchronously.

Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 include/linux/device.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 43d183a..aa14b95 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -200,6 +200,8 @@ extern struct klist *bus_get_device_klist(struct bus_type *bus);
  * @owner:	The module owner.
  * @mod_name:	Used for built-in modules.
  * @suppress_bind_attrs: Disables bind/unbind via sysfs.
+ * @sync_probe:	Use this to annotate drivers which don't work well with
+ *		async probe.
  * @of_match_table: The open firmware table.
  * @acpi_match_table: The ACPI match table.
  * @probe:	Called to query the existence of a specific device,
@@ -233,6 +235,7 @@ struct device_driver {
 	const char		*mod_name;	/* used for built-in modules */
 
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
+	bool sync_probe;
 
 	const struct of_device_id	*of_match_table;
 	const struct acpi_device_id	*acpi_match_table;
-- 
2.1.1

