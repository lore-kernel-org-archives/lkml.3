Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaKJQhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:37:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbaKJQhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:37:17 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 2/2] Tools: hv: vssdaemon: skip all filesystems mounted readonly
Date: Mon, 10 Nov 2014 17:37:02 +0100
Message-Id: <1415637422-27880-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
References: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of making a list of exceptions for readonly filesystems
in addition to iso9660 we already have it is better to skip freeze
operation for all readonly-mounted filesystems.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_vss_daemon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index ee44f0d..5e63f70 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -102,7 +102,7 @@ static int vss_operate(int operation)
 	while ((ent = getmntent(mounts))) {
 		if (strncmp(ent->mnt_fsname, match, strlen(match)))
 			continue;
-		if (strcmp(ent->mnt_type, "iso9660") == 0)
+		if (hasmntopt(ent, MNTOPT_RO) != NULL)
 			continue;
 		if (strcmp(ent->mnt_type, "vfat") == 0)
 			continue;
-- 
1.9.3

