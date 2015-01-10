Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbbAJFH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:07:58 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42428
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbbAJFGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:06:48 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 2/5] Tools: hv: remove unused bytes_written from kvp_update_file()
Date: Fri,  9 Jan 2015 22:18:52 -0800
Message-Id: <1420870735-2265-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1420870735-2265-1-git-send-email-kys@microsoft.com>
References: <1420870690-2223-1-git-send-email-kys@microsoft.com>
 <1420870735-2265-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

fwrite() does not actually return the number of bytes written and
this value is being ignored anyway and ferror() is being called to
check for an error. As we assign to this variable and never use it
we get the following compile-time warning:
hv_kvp_daemon.c:149:9: warning: variable .bytes_written. set but not used [-Wunused-but-set-variable]
Remove bytes_written completely.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 6a6432a..5a274ca 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -147,7 +147,6 @@ static void kvp_release_lock(int pool)
 static void kvp_update_file(int pool)
 {
 	FILE *filep;
-	size_t bytes_written;
 
 	/*
 	 * We are going to write our in-memory registry out to
@@ -163,8 +162,7 @@ static void kvp_update_file(int pool)
 		exit(EXIT_FAILURE);
 	}
 
-	bytes_written = fwrite(kvp_file_info[pool].records,
-				sizeof(struct kvp_record),
+	fwrite(kvp_file_info[pool].records, sizeof(struct kvp_record),
 				kvp_file_info[pool].num_records, filep);
 
 	if (ferror(filep) || fclose(filep)) {
-- 
1.7.4.1

