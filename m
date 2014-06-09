Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515AbaFIIzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:55:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58593 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932249AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Edward Lin <yidi.lin@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 129/146] ACPI: blacklist win8 OSI for Dell Inspiron 7737
Date: Mon,  9 Jun 2014 10:51:04 +0200
Message-Id: <27ef9885fcca147c91d26bed5d49f69b57c9433d.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Lin <yidi.lin@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b753631b3576bf343151a82513c5d56fcda1e24f upstream.

With win8 capabiltiy, the machine will boot itself immediately after
shutdown command has executed.

Work around this issue by disabling win8 capcability.  This workaround
also makes wireless hotkey work.

Signed-off-by: Edward Lin <yidi.lin@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/blacklist.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index bf180bbb2bd8..16eb678c0f3d 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -345,6 +345,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_VERSION, "2349D15"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_win8,
+	.ident = "Dell Inspiron 7737",
+	.matches = {
+		    DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		    DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7737"),
+		},
+	},
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
-- 
1.9.3

