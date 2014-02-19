Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaBSRjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:39:03 -0500
Received: from mail-pb0-f67.google.com ([209.85.160.67]:56940 "EHLO
	mail-pb0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaBSRjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:39:00 -0500
From: Zhang Yi <yix.x.zhang@gmail.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Yi <yix.x.zhang@gmail.com>
Subject: [PATCH] Add eMMC 5.0 support
Date: Wed, 19 Feb 2014 21:47:57 +0800
Message-Id: <1392817677-4755-1-git-send-email-yix.x.zhang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code will exist when read eMMC 5.0, add support for it

Signed-off-by: Zhang Yi <yix.x.zhang@gmail.com>
---
 mmc_cmds.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mmc_cmds.c b/mmc_cmds.c
index b8afa74..5edf42b 100644
--- a/mmc_cmds.c
+++ b/mmc_cmds.c
@@ -722,6 +722,9 @@ int do_read_extcsd(int nargs, char **argv)
 	ext_csd_rev = ext_csd[192];
 
 	switch (ext_csd_rev) {
+	case 7:
+		str = "5.0";
+		break;
 	case 6:
 		str = "4.5";
 		break;
-- 
1.7.9.5

