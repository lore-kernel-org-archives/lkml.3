Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbbASVoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:44:06 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53422 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbbASVnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:43:52 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/3] sysfs: Document struct attribute_group
Date: Mon, 19 Jan 2015 13:43:26 -0800
Message-Id: <1421703806-29791-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421703806-29791-1-git-send-email-linux@roeck-us.net>
References: <1421703806-29791-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54BD7A98.01C7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 12
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document variables defined in struct attribute_group to ensure
correct usage.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/sysfs.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index ddad161..99382c0 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -57,6 +57,21 @@ do {							\
 #define sysfs_attr_init(attr) do {} while (0)
 #endif
 
+/**
+ * struct attribute_group - data structure used to declare an attribute group.
+ * @name:	Optional: Attribute group name
+ *		If specified, the attribute group will be created in
+ *		a new subdirectory with this name.
+ * @is_visible:	Optional: Function to return permissions associated with an
+ *		attribute of the group. Will be called repeatedly for each
+ *		attribute in the group. Only read/write permissions as well as
+ *		SYSFS_PREALLOC are accepted. Must return 0 if an attribute is
+ *		not visible. The returned value will replace static permissions
+ *		defined in struct attribute or struct bin_attribute.
+ * @attrs:	Pointer to NULL terminated list of attributes.
+ * @bin_attrs:	Pointer to NULL terminated list of binary attributes.
+ *		Either attrs or bin_attrs or both must be provided.
+ */
 struct attribute_group {
 	const char		*name;
 	umode_t			(*is_visible)(struct kobject *,
-- 
2.1.0

