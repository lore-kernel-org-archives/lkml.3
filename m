Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaLTMZH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:25:07 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63405 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaLTMZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:25:03 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] s390: cio: idset.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 13:27:49 +0100
Message-Id: <1419078469-30933-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
idset_clear() idset_sch_get_first()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/s390/cio/idset.c |   20 --------------------
 drivers/s390/cio/idset.h |    2 --
 2 files changed, 22 deletions(-)

diff --git a/drivers/s390/cio/idset.c b/drivers/s390/cio/idset.c
index 5a99908..b3e06a7 100644
--- a/drivers/s390/cio/idset.c
+++ b/drivers/s390/cio/idset.c
@@ -38,11 +38,6 @@ void idset_free(struct idset *set)
 	vfree(set);
 }
 
-void idset_clear(struct idset *set)
-{
-	memset(set->bitmap, 0, bitmap_size(set->num_ssid, set->num_id));
-}
-
 void idset_fill(struct idset *set)
 {
 	memset(set->bitmap, 0xff, bitmap_size(set->num_ssid, set->num_id));
@@ -103,21 +98,6 @@ int idset_sch_contains(struct idset *set, struct subchannel_id schid)
 	return idset_contains(set, schid.ssid, schid.sch_no);
 }
 
-int idset_sch_get_first(struct idset *set, struct subchannel_id *schid)
-{
-	int ssid = 0;
-	int id = 0;
-	int rc;
-
-	rc = idset_get_first(set, &ssid, &id);
-	if (rc) {
-		init_subchannel_id(schid);
-		schid->ssid = ssid;
-		schid->sch_no = id;
-	}
-	return rc;
-}
-
 int idset_is_empty(struct idset *set)
 {
 	return bitmap_empty(set->bitmap, set->num_ssid * set->num_id);
diff --git a/drivers/s390/cio/idset.h b/drivers/s390/cio/idset.h
index 06d3bc0..22b5810 100644
--- a/drivers/s390/cio/idset.h
+++ b/drivers/s390/cio/idset.h
@@ -11,7 +11,6 @@
 struct idset;
 
 void idset_free(struct idset *set);
-void idset_clear(struct idset *set);
 void idset_fill(struct idset *set);
 
 struct idset *idset_sch_new(void);
@@ -19,7 +18,6 @@ void idset_sch_add(struct idset *set, struct subchannel_id id);
 void idset_sch_del(struct idset *set, struct subchannel_id id);
 void idset_sch_del_subseq(struct idset *set, struct subchannel_id schid);
 int idset_sch_contains(struct idset *set, struct subchannel_id id);
-int idset_sch_get_first(struct idset *set, struct subchannel_id *id);
 int idset_is_empty(struct idset *set);
 void idset_add_set(struct idset *to, struct idset *from);
 
-- 
1.7.10.4

