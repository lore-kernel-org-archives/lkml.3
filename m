Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab3DWUvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:51:36 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:36513
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab3DWUvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:51:33 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 5/5] [PATCH 2/2] tools: hv: skip iso9660 mounts in hv_vss_daemon
Date: Tue, 23 Apr 2013 14:24:01 -0700
Message-Id: <1366752241-357-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366752241-357-1-git-send-email-kys@microsoft.com>
References: <1366752210-318-1-git-send-email-kys@microsoft.com>
 <1366752241-357-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

freeze does not work for iso9660 filesystems. A ENOSUPP may be caught
in the freeze case, but the subsequent thaw call would fail and leads to
a false error.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 830d606..f06cd8c 100644
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

