Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab3GYSEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:04:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43420 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3GYRwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:52:01 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V8 16/33] bio: add bvec_length(), like iov_length()
Date: Thu, 25 Jul 2013 12:50:42 -0500
Message-Id: <1374774659-13121-17-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
index ec48bac..4fd5253 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -307,6 +307,14 @@ extern struct bio_vec *bvec_alloc(gfp_t, int, unsigned long *, mempool_t *);
 extern void bvec_free(mempool_t *, struct bio_vec *, unsigned int);
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
1.8.3.4

