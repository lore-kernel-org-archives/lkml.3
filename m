Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3GIPoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:44:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab3GIPoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:44:10 -0400
Subject: [PATCH 3/3] firmware/dmi_scan: Constify strings
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1373384438.4391.6.camel@chaos.site>
References: <1373384438.4391.6.camel@chaos.site>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 09 Jul 2013 17:43:54 +0200
Message-ID: <1373384634.4391.10.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add const to all DMI string pointers where this is possible. This
fixes a checkpatch warning.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/firmware/dmi_scan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-3.10-rc0.orig/drivers/firmware/dmi_scan.c	2013-05-04 11:20:48.321082162 +0200
+++ linux-3.10-rc0/drivers/firmware/dmi_scan.c	2013-05-04 11:20:52.808187924 +0200
@@ -14,7 +14,7 @@
  * of and an antecedent to, SMBIOS, which stands for System
  * Management BIOS.  See further: http://www.dmtf.org/standards
  */
-static char dmi_empty_string[] = "        ";
+static const char dmi_empty_string[] = "        ";
 
 static u16 __initdata dmi_ver;
 /*
@@ -49,7 +49,7 @@ static const char * __init dmi_string_no
 	return "";
 }
 
-static char * __init dmi_string(const struct dmi_header *dm, u8 s)
+static const char * __init dmi_string(const struct dmi_header *dm, u8 s)
 {
 	const char *bp = dmi_string_nosave(dm, s);
 	char *str;
@@ -133,7 +133,7 @@ static int __init dmi_checksum(const u8
 	return sum == 0;
 }
 
-static char *dmi_ident[DMI_STRING_MAX];
+static const char *dmi_ident[DMI_STRING_MAX];
 static LIST_HEAD(dmi_devices);
 int dmi_available;
 
@@ -144,7 +144,7 @@ static void __init dmi_save_ident(const
 		int string)
 {
 	const char *d = (const char *) dm;
-	char *p;
+	const char *p;
 
 	if (dmi_ident[slot])
 		return;
@@ -252,7 +252,7 @@ static void __init dmi_save_oem_strings_
 	struct dmi_device *dev;
 
 	for (i = 1; i <= count; i++) {
-		char *devname = dmi_string(dm, i);
+		const char *devname = dmi_string(dm, i);
 
 		if (devname == dmi_empty_string)
 			continue;


-- 
Jean Delvare
Suse L3

