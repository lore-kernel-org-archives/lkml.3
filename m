Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934940Ab3CZQrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:47:19 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:56129 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462Ab3CZQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:47:18 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/TwSabzUg=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 2/2] tools: hv: skip iso9660 mounts in hv_vss_daemon
Date: Tue, 26 Mar 2013 17:47:10 +0100
Message-Id: <1364316430-29655-2-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364316430-29655-1-git-send-email-olaf@aepfle.de>
References: <1364316430-29655-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freeze does not work for iso9660 filesystems. A ENOSUPP may be catched
in the freeze case, but the subsequent thaw call would fail and leads to
a false error.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_vss_daemon.c | 2 ++
 1 file changed, 2 insertions(+)

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
