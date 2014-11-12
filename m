Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbaKLCyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:54:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739AbaKLBmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:42:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 099/203] ext4: dont check quota format when there are no quota files
Date: Wed, 12 Nov 2014 10:16:09 +0900
Message-Id: <20141112011547.228467345@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 279bf6d390933d5353ab298fcc306c391a961469 upstream.

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1706,13 +1706,6 @@ static int parse_options(char *options,
 					"not specified");
 			return 0;
 		}
-	} else {
-		if (sbi->s_jquota_fmt) {
-			ext4_msg(sb, KERN_ERR, "journaled quota format "
-					"specified with no journaling "
-					"enabled");
-			return 0;
-		}
 	}
 #endif
 	if (test_opt(sb, DIOREAD_NOLOCK)) {


