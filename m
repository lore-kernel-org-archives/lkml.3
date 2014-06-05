Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaFEEkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:40:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaFEEVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 148/214] efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
Date: Wed,  4 Jun 2014 21:18:31 -0700
Message-Id: <20140605041659.713311758@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit ca0ba26fbbd2d81c43085df49ce0abfe34535a90 upstream.

The 'CONFIG_' prefix is not implicit in IS_ENABLED().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 


