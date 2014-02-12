Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaBLPta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:49:30 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45816
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaBLPt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:49:28 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Tools: hv: vssdaemon: Ignore VFAT mounts during the Freeze operation
Date: Wed, 12 Feb 2014 08:40:22 -0800
Message-Id: <1392223222-18037-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the guest has a FAT file system mounted, skip it during the FREEZE
operation. With this change we can support host initiated backup of
the guest even when the guest may have FAT file systems mounted.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 520de3304..6a213b8 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -87,6 +87,8 @@ static int vss_operate(int operation)
 			continue;
 		if (strcmp(ent->mnt_type, "iso9660") == 0)
 			continue;
+		if (strcmp(ent->mnt_type, "vfat") == 0)
+			continue;
 		if (strcmp(ent->mnt_dir, "/") == 0) {
 			root_seen = 1;
 			continue;
-- 
1.7.4.1

