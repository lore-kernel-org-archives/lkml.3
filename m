Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965855Ab3GSF1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:27:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804Ab3GSF1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 57/72] ext4: dont show usrquota/grpquota twice in /proc/mounts
Date: Thu, 18 Jul 2013 22:26:14 -0700
Message-Id: <20130719052603.753520433@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit ad065dd01662ae22138899e6b1c8eeb3a529964f upstream.

We now print mount options in a generic fashion in
ext4_show_options(), so we shouldn't be explicitly printing the
{usr,grp}quota options in ext4_show_quota_options().

Without this patch, /proc/mounts can look like this:

 /dev/vdb /vdb ext4 rw,relatime,quota,usrquota,data=ordered,usrquota 0 0
                                      ^^^^^^^^              ^^^^^^^^

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1684,12 +1684,6 @@ static inline void ext4_show_quota_optio
 
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
-
-	if (test_opt(sb, USRQUOTA))
-		seq_puts(seq, ",usrquota");
-
-	if (test_opt(sb, GRPQUOTA))
-		seq_puts(seq, ",grpquota");
 #endif
 }
 


