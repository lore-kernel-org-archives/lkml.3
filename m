Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3CYBP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33940 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942Ab3CYBPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:53 -0400
Message-Id: <20130325010531.791492307@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Seth Forshee <seth.forshee@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 076/104] efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit ca0ba26fbbd2d81c43085df49ce0abfe34535a90 upstream.

The 'CONFIG_' prefix is not implicit in IS_ENABLED().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efivars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -93,7 +93,7 @@ MODULE_VERSION(EFIVARS_VERSION);
 #define DUMP_NAME_LEN 52
 
 static bool efivars_pstore_disable =
-	IS_ENABLED(EFI_VARS_PSTORE_DEFAULT_DISABLE);
+	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
 
 module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
 


