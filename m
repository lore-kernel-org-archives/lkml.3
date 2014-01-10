Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaAJPM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:12:29 -0500
Received: from mail1.windriver.com ([147.11.146.13]:55057 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAJPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:12:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH-next] drivers/hwmon: remove new __cpuinit usage from coretemp.c
Date: Fri, 10 Jan 2014 10:10:23 -0500
Message-ID: <1389366623-26552-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit da9e8c7a7b99b245c464ff45c7bde38a4b510019 ("hwmon: (coretemp)
Use PCI host bridge ID to identify CPU if necessary") added a new
instance of the __cpuinit macro usage.

We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what
we want to see at this point in time, as it will break once
the stubs are gone.

Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Patch based on today's linux-next tree, so if hwmon next content
 gets rebased, then the above commit ID will be invalidated; if it
 _does_ get rebased, then feel free to squash this fix into the orig.]

 drivers/hwmon/coretemp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 6e0579e80538..f44549f7c445 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -197,7 +197,7 @@ struct tjmax_pci {
 	int tjmax;
 };
 
-static const struct tjmax_pci tjmax_pci_table[] __cpuinitconst = {
+static const struct tjmax_pci tjmax_pci_table[] = {
 	{ 0x0708, 110000 },	/* CE41x0 (Sodaville ) */
 	{ 0x0c72, 102000 },	/* Atom S1240 (Centerton) */
 	{ 0x0c73, 95000 },	/* Atom S1220 (Centerton) */
-- 
1.8.5.2

