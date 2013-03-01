Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3CAUZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:25:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3CATpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Carlos Maiolino <cmaiolino@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [ 10/77] quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
Date: Fri,  1 Mar 2013 11:43:55 -0800
Message-Id: <20130301194353.097837448@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit c3ad83d9efdfe6a86efd44945a781f00c879b7b4 upstream.

Otherwise, ext4 file systems with the quota featured enable will get a
very confusing "No such process" error message if the quota code is
built as a module and the quota_v2 module has not been loaded.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/quota.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -405,6 +405,7 @@ struct quota_module_name {
 #define INIT_QUOTA_MODULE_NAMES {\
 	{QFMT_VFS_OLD, "quota_v1"},\
 	{QFMT_VFS_V0, "quota_v2"},\
+	{QFMT_VFS_V1, "quota_v2"},\
 	{0, NULL}}
 
 #endif /* _QUOTA_ */


