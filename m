Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3CDETl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:19:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60751 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429Ab3CDDmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:38 -0500
Message-Id: <20130304033709.003966848@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:21 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Theodore Tso <tytso@mit.edu>,
        Carlos Maiolino <cmaiolino@redhat.com>, Jan Kara <jack@suse.cz>
Subject: [ 014/153] quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit c3ad83d9efdfe6a86efd44945a781f00c879b7b4 upstream.

Otherwise, ext4 file systems with the quota featured enable will get a
very confusing "No such process" error message if the quota code is
built as a module and the quota_v2 module has not been loaded.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/quota.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -413,6 +413,7 @@ struct quota_module_name {
 #define INIT_QUOTA_MODULE_NAMES {\
 	{QFMT_VFS_OLD, "quota_v1"},\
 	{QFMT_VFS_V0, "quota_v2"},\
+	{QFMT_VFS_V1, "quota_v2"},\
 	{0, NULL}}
 
 #endif /* __KERNEL__ */


