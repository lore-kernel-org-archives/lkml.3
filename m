Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbaF1Sq2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:46:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaF1Rtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maurizio Lombardi <mlombard@redhat.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 039/110] ext4: fix wrong assert in ext4_mb_normalize_request()
Date: Sat, 28 Jun 2014 10:46:36 -0700
Message-Id: <20140628174547.494665704@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

commit b5b60778558cafad17bbcbf63e0310bd3c68eb17 upstream.

The variable "size" is expressed as number of blocks and not as
number of clusters, this could trigger a kernel panic when using
ext4 with the size of a cluster different from the size of a block.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3135,7 +3135,7 @@ ext4_mb_normalize_request(struct ext4_al
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
-	BUG_ON(size <= 0 || size > EXT4_CLUSTERS_PER_GROUP(ac->ac_sb));
+	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
 


