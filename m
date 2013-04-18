Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966079Ab3DRJTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:19:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40363 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965227Ab3DRJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 72/72] efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
Date: Thu, 18 Apr 2013 10:16:57 +0100
Message-Id: <1366276617-3553-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit ca0ba26fbbd2d81c43085df49ce0abfe34535a90 upstream.

The 'CONFIG_' prefix is not implicit in IS_ENABLED().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firmware/efivars.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index af8fec1..303bc8e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -93,7 +93,7 @@ MODULE_VERSION(EFIVARS_VERSION);
 #define DUMP_NAME_LEN 52
 
 static bool efivars_pstore_disable =
-	IS_ENABLED(EFI_VARS_PSTORE_DEFAULT_DISABLE);
+	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
 
 module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
 
-- 
1.8.1.2

