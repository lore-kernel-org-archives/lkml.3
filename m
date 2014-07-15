Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428AbaGOXYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:24:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934155AbaGOXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.15 51/84] ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
Date: Tue, 15 Jul 2014 16:17:48 -0700
Message-Id: <20140715231714.736103677@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 94d4c066a4ff170a2671b1a9b153febbf36796f6 upstream.

We are spending a lot of time explaining to users what this error
means.  Let's try to improve the message to avoid this problem.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -751,8 +751,8 @@ void ext4_mb_generate_buddy(struct super
 
 	if (free != grp->bb_free) {
 		ext4_grp_locked_error(sb, group, 0, 0,
-				      "%u clusters in bitmap, %u in gd; "
-				      "block bitmap corrupt.",
+				      "block bitmap and bg descriptor "
+				      "inconsistent: %u vs %u free clusters",
 				      free, grp->bb_free);
 		/*
 		 * If we intend to continue, we consider group descriptor


