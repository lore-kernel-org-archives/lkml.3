Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaE0IWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:22:38 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:59495 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbaE0IW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:22:29 -0400
Message-ID: <1401178947.15450.2.camel@x220>
Subject: [PATCH] [TRIVIAL] befs: remove check for CONFIG_BEFS_RW
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 27 May 2014 10:22:27 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2014 08:22:28.0038 (UTC) FILETIME=[CBE3C660:01CF7984]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Befs contains a check for CONFIG_BEFS_RW for over a decade now. The
related Kconfig symbol never existed, so this check always evaluated to
true. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested. Does this still qualify as trivial?

 fs/befs/linuxvfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index d626756ff721..46149526b580 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -808,13 +808,11 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
 	befs_debug(sb, "---> %s", __func__);
 
-#ifndef CONFIG_BEFS_RW
 	if (!(sb->s_flags & MS_RDONLY)) {
 		befs_warning(sb,
 			     "No write support. Marking filesystem read-only");
 		sb->s_flags |= MS_RDONLY;
 	}
-#endif				/* CONFIG_BEFS_RW */
 
 	/*
 	 * Set dummy blocksize to read super block.
-- 
1.9.3

