Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaCEQLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:11:10 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:37770 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCEQLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:11:07 -0500
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biederman <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] kernfs: fix off by one error.
Date: Wed,  5 Mar 2014 17:10:52 +0100
Message-Id: <74f5a436ebf5c13ed89a81c47ba09a6549e385f6.1394035568.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hash values 0 and 1 are reserved for magic directory entries, but
the code only prevents names hashing to 0. This patch fixes the test
to also prevent hash value 1.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Cc: <stable@vger.kernel.org>
---
 fs/kernfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index bd6e18b..39c0143 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -37,7 +37,7 @@ static unsigned int kernfs_name_hash(const char *name, const void *ns)
 	hash = (end_name_hash(hash) ^ hash_ptr((void *)ns, 31));
 	hash &= 0x7fffffffU;
 	/* Reserve hash numbers 0, 1 and INT_MAX for magic directory entries */
-	if (hash < 1)
+	if (hash < 2)
 		hash += 2;
 	if (hash >= INT_MAX)
 		hash = INT_MAX - 1;
-- 
1.7.10.4

