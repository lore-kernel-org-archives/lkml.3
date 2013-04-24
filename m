Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3DXORh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:17:37 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41827
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab3DXOQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:16:27 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 6/7] tools: hv: skip iso9660 mounts in hv_vss_daemon
Date: Wed, 24 Apr 2013 07:48:53 -0700
Message-Id: <1366814934-4461-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366814934-4461-1-git-send-email-kys@microsoft.com>
References: <1366814913-4422-1-git-send-email-kys@microsoft.com>
 <1366814934-4461-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

fsreeze does not work for iso9660 filesystems. A ENOSUPP may be caught
in the freeze case, but the subsequent thaw call would fail and leads to
a false error.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index dc73a89..712cfc5 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -88,6 +88,8 @@ static int vss_operate(int operation)
 	while((ent = getmntent(mounts))) {
 		if (strncmp(ent->mnt_fsname, match, strlen(match)))
 			continue;
+		if (strcmp(ent->mnt_type, "iso9660") == 0)
+			continue;
 		if (strcmp(ent->mnt_dir, "/") == 0) {
 			root_seen = 1;
 			continue;
-- 
1.7.4.1

