Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaFWBfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:35:01 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39768 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbaFWBcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:53 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 11/18] staging/lustre/obdclass: Fix uninitialized variables
Date: Sun, 22 Jun 2014 21:32:15 -0400
Message-Id: <1403487142-4880-12-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

'sd.page_link' is used uninitialized in this function.
'ss.page_link' is used uninitialized in this function.
'sl.page_link' is used uninitialized in this function.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/10613
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/capa.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/lustre/lustre/obdclass/capa.c b/drivers/staging/lustre/lustre/obdclass/capa.c
index be1c613..cf1c497 100644
--- a/drivers/staging/lustre/lustre/obdclass/capa.c
+++ b/drivers/staging/lustre/lustre/obdclass/capa.c
@@ -279,6 +279,7 @@ int capa_hmac(__u8 *hmac, struct lustre_capa *capa, __u8 *key)
 	}
 	keylen = alg->ha_keylen;
 
+	sg_init_table(&sl, 1);
 	sg_set_page(&sl, virt_to_page(capa),
 		    offsetof(struct lustre_capa, lc_hmac),
 		    (unsigned long)(capa) % PAGE_CACHE_SIZE);
@@ -320,9 +321,11 @@ int capa_encrypt_id(__u32 *d, __u32 *s, __u8 *key, int keylen)
 		GOTO(out, rc);
 	}
 
+	sg_init_table(&sd, 1);
 	sg_set_page(&sd, virt_to_page(d), 16,
 		    (unsigned long)(d) % PAGE_CACHE_SIZE);
 
+	sg_init_table(&ss, 1);
 	sg_set_page(&ss, virt_to_page(s), 16,
 		    (unsigned long)(s) % PAGE_CACHE_SIZE);
 	desc.tfm   = tfm;
@@ -370,9 +373,11 @@ int capa_decrypt_id(__u32 *d, __u32 *s, __u8 *key, int keylen)
 		GOTO(out, rc);
 	}
 
+	sg_init_table(&sd, 1);
 	sg_set_page(&sd, virt_to_page(d), 16,
 		    (unsigned long)(d) % PAGE_CACHE_SIZE);
 
+	sg_init_table(&ss, 1);
 	sg_set_page(&ss, virt_to_page(s), 16,
 		    (unsigned long)(s) % PAGE_CACHE_SIZE);
 
-- 
1.9.0

