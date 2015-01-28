Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763990AbbA2DR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:17:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46954 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbbA2CgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 068/139] dm crypt: use memzero_explicit for on-stack buffer
Date: Wed, 28 Jan 2015 14:20:11 -0800
Message-Id: <1422483682-15393-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Broz <gmazyland@gmail.com>

commit 1a71d6ffe18c0d0f03fc8531949cc8ed41d702ee upstream.

Use memzero_explicit to cleanup sensitive data allocated on stack
to prevent the compiler from optimizing and removing memset() calls.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8c148f4..5e3f7de 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -711,7 +711,7 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
 		crypto_xor(data + i * 8, buf, 8);
 out:
-	memset(buf, 0, sizeof(buf));
+	memzero_explicit(buf, sizeof(buf));
 	return r;
 }
 
-- 
1.9.1

