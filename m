Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029Ab3CHW6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:58:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36039 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057Ab3CHWwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:46 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V7 -next 16/33] bio: add bvec_length(), like iov_length()
Date: Fri,  8 Mar 2013 16:52:11 -0600
Message-Id: <1362783148-22736-17-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/bio.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5f5491767..d670bee 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -311,6 +311,14 @@ extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set
 extern void bvec_free_bs(struct bio_set *, struct bio_vec *, unsigned int);
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
+static inline ssize_t bvec_length(const struct bio_vec *bvec, unsigned long nr)
+{
+	ssize_t bytes = 0;
+	while (nr--)
+		bytes += (bvec++)->bv_len;
+	return bytes;
+}
+
 #ifdef CONFIG_BLK_CGROUP
 int bio_associate_current(struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
-- 
1.8.1.5

