Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3CATyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:54:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3CATqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Carlos Maiolino <cmaiolino@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [ 01/30] quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
Date: Fri,  1 Mar 2013 11:45:22 -0800
Message-Id: <20130301194528.171681454@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -413,6 +413,7 @@ struct quota_module_name {
 #define INIT_QUOTA_MODULE_NAMES {\
 	{QFMT_VFS_OLD, "quota_v1"},\
 	{QFMT_VFS_V0, "quota_v2"},\
+	{QFMT_VFS_V1, "quota_v2"},\
 	{0, NULL}}
 
 #else


