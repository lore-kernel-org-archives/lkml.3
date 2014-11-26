Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaKZRkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:40:45 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52592 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaKZRkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:40:24 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org, andrew@lunn.ch,
        s.hauer@pengutronix.de
Subject: [PATCH v2 2/2] of: support passing console options with stdout-path
Date: Wed, 26 Nov 2014 17:40:40 +0000
Message-Id: <1417023640-23464-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
References: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support specifying console options (like with console=ttyXN,<options>)
by appending them to the stdout-path property after a separating ':'.

Example:
        stdout-path = "uart0:115200";

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/of/base.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 3e764bd..d265514 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -37,6 +37,7 @@ EXPORT_SYMBOL(of_allnodes);
 struct device_node *of_chosen;
 struct device_node *of_aliases;
 struct device_node *of_stdout;
+static char *of_stdout_options;
 
 struct kset *of_kset;
 
@@ -1844,7 +1845,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 		if (IS_ENABLED(CONFIG_PPC) && !name)
 			name = of_get_property(of_aliases, "stdout", NULL);
 		if (name)
-			of_stdout = of_find_node_by_path(name, NULL);
+			of_stdout = of_find_node_by_path(name, &of_stdout_options);
 	}
 
 	if (!of_aliases)
@@ -1970,7 +1971,7 @@ bool of_console_check(struct device_node *dn, char *name, int index)
 {
 	if (!dn || dn != of_stdout || console_set_on_cmdline)
 		return false;
-	return !add_preferred_console(name, index, NULL);
+	return !add_preferred_console(name, index, of_stdout_options);
 }
 EXPORT_SYMBOL_GPL(of_console_check);
 
-- 
1.7.10.4

