Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3A2QYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:24:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35180 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3A2QYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:24:24 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V6 14/30] bio: add bvec_length(), like iov_length()
Date: Tue, 29 Jan 2013 10:23:27 -0600
Message-Id: <1359476623-10544-15-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
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
index 820e7aa..f5f9829 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -290,6 +290,14 @@ extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set
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
1.8.1.1

