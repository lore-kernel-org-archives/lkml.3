Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab3CZWu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:50:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3CZWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 91/98] efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
Date: Tue, 26 Mar 2013 15:43:20 -0700
Message-Id: <20130326224251.898362209@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit ca0ba26fbbd2d81c43085df49ce0abfe34535a90 upstream.

The 'CONFIG_' prefix is not implicit in IS_ENABLED().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efivars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -104,7 +104,7 @@ MODULE_VERSION(EFIVARS_VERSION);
 #define GUID_LEN 36
 
 static bool efivars_pstore_disable =
-	IS_ENABLED(EFI_VARS_PSTORE_DEFAULT_DISABLE);
+	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
 
 module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
 


