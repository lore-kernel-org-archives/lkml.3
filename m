Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3CKS7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:59:00 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52387 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3CKS66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:58:58 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: matt@console-pimps.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Lingzhu Xiang <lxiang@redhat.com>
Subject: [PATCH] efivars: allow efi pstore variable when validate filename
Date: Tue, 12 Mar 2013 02:57:28 +0800
Message-Id: <1363028248-27788-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We mount efivarfs fail after pstore generated 'dump-type*' variables and
reboot.

This issue introduced by commit 47f531e8ba3bc3901a0c493f4252826c41dea1a1
(efivarfs: Validate filenames much more aggressively)

The pstore variable is 'dump-type*-*-*-*-GUID'style, it could not pass
the "GUID should be right after the first '-'" check. This patch allow
the variable name that has 'dump-type' pass the name check.

Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/firmware/efivars.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 3edade0..ab07f7f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -930,7 +930,7 @@ static bool efivarfs_valid_name(const char *str, int len)
 		return false;
 
 	/* GUID should be right after the first '-' */
-	if (s - 1 != strchr(str, '-'))
+	if (s - 1 != strchr(str, '-') && !strstarts(str, "dump-type"))
 		return false;
 
 	/*
-- 
1.6.4.2

