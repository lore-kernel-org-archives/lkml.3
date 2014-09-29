Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaI2JDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:03:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51123 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaI2JDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:03:46 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/6] ALSA: ctxfi: changed void * to struct hw *
Date: Mon, 29 Sep 2014 14:33:21 +0530
Message-Id: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in the code we have void *hw and while using we are always typecasting
it to (struct hw *). it is better to use void type of pointer when we
store different types of pointer , but in this code we are only having
struct hw.
So changed all the relevant reference of void *hw to struct hw *hw,
without any modification of the existing code logic.
the next patch of the series will remove the typecasting which is
not required now.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctamixer.c   | 4 ++--
 sound/pci/ctxfi/ctamixer.h   | 4 ++--
 sound/pci/ctxfi/ctatc.c      | 4 ++--
 sound/pci/ctxfi/ctatc.h      | 2 +-
 sound/pci/ctxfi/ctdaio.c     | 4 ++--
 sound/pci/ctxfi/ctdaio.h     | 6 +++---
 sound/pci/ctxfi/ctresource.c | 5 +++--
 sound/pci/ctxfi/ctresource.h | 9 +++++----
 sound/pci/ctxfi/ctsrc.c      | 4 ++--
 sound/pci/ctxfi/ctsrc.h      | 4 ++--
 10 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/sound/pci/ctxfi/ctamixer.c b/sound/pci/ctxfi/ctamixer.c
index fed6e6a..4671cbe7 100644
--- a/sound/pci/ctxfi/ctamixer.c
+++ b/sound/pci/ctxfi/ctamixer.c
@@ -296,7 +296,7 @@ static int put_amixer_rsc(struct amixer_mgr *mgr, struct amixer *amixer)
 	return 0;
 }
 
-int amixer_mgr_create(void *hw, struct amixer_mgr **ramixer_mgr)
+int amixer_mgr_create(struct hw *hw, struct amixer_mgr **ramixer_mgr)
 {
 	int err;
 	struct amixer_mgr *amixer_mgr;
@@ -449,7 +449,7 @@ static int put_sum_rsc(struct sum_mgr *mgr, struct sum *sum)
 	return 0;
 }
 
-int sum_mgr_create(void *hw, struct sum_mgr **rsum_mgr)
+int sum_mgr_create(struct hw *hw, struct sum_mgr **rsum_mgr)
 {
 	int err;
 	struct sum_mgr *sum_mgr;
diff --git a/sound/pci/ctxfi/ctamixer.h b/sound/pci/ctxfi/ctamixer.h
index cc49e5a..6fa5eff 100644
--- a/sound/pci/ctxfi/ctamixer.h
+++ b/sound/pci/ctxfi/ctamixer.h
@@ -45,7 +45,7 @@ struct sum_mgr {
 };
 
 /* Constructor and destructor of daio resource manager */
-int sum_mgr_create(void *hw, struct sum_mgr **rsum_mgr);
+int sum_mgr_create(struct hw *hw, struct sum_mgr **rsum_mgr);
 int sum_mgr_destroy(struct sum_mgr *sum_mgr);
 
 /* Define the descriptor of a amixer resource */
@@ -90,7 +90,7 @@ struct amixer_mgr {
 };
 
 /* Constructor and destructor of amixer resource manager */
-int amixer_mgr_create(void *hw, struct amixer_mgr **ramixer_mgr);
+int amixer_mgr_create(struct hw *hw, struct amixer_mgr **ramixer_mgr);
 int amixer_mgr_destroy(struct amixer_mgr *amixer_mgr);
 
 #endif /* CTAMIXER_H */
diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index d92a08c..04e54cc 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -106,11 +106,11 @@ static struct {
 			    .public_name = "Mixer"}
 };
 
-typedef int (*create_t)(void *, void **);
+typedef int (*create_t)(struct hw *, void **);
 typedef int (*destroy_t)(void *);
 
 static struct {
-	int (*create)(void *hw, void **rmgr);
+	int (*create)(struct hw *hw, void **rmgr);
 	int (*destroy)(void *mgr);
 } rsc_mgr_funcs[NUM_RSCTYP] = {
 	[SRC] 		= { .create 	= (create_t)src_mgr_create,
diff --git a/sound/pci/ctxfi/ctatc.h b/sound/pci/ctxfi/ctatc.h
index 5f11ca2..5641334 100644
--- a/sound/pci/ctxfi/ctatc.h
+++ b/sound/pci/ctxfi/ctatc.h
@@ -131,7 +131,7 @@ struct ct_atc {
 	/* Don't touch! Used for internal object. */
 	void *rsc_mgrs[NUM_RSCTYP]; /* chip resource managers */
 	void *mixer;		/* internal mixer object */
-	void *hw;		/* chip specific hardware access object */
+	struct hw *hw;		/* chip specific hardware access object */
 	void **daios;		/* digital audio io resources */
 	void **pcm;		/* SUMs for collecting all pcm stream */
 	void **srcs;		/* Sample Rate Converters for input signal */
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index 6f0654e..7541641 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -331,7 +331,7 @@ static struct dai_rsc_ops dai_ops = {
 
 static int daio_rsc_init(struct daio *daio,
 			 const struct daio_desc *desc,
-			 void *hw)
+			 struct hw *hw)
 {
 	int err;
 	unsigned int idx_l, idx_r;
@@ -692,7 +692,7 @@ static int daio_mgr_commit_write(struct daio_mgr *mgr)
 	return 0;
 }
 
-int daio_mgr_create(void *hw, struct daio_mgr **rdaio_mgr)
+int daio_mgr_create(struct hw *hw, struct daio_mgr **rdaio_mgr)
 {
 	int err, i;
 	struct daio_mgr *daio_mgr;
diff --git a/sound/pci/ctxfi/ctdaio.h b/sound/pci/ctxfi/ctdaio.h
index 85ccb6e..e4817de 100644
--- a/sound/pci/ctxfi/ctdaio.h
+++ b/sound/pci/ctxfi/ctdaio.h
@@ -53,14 +53,14 @@ struct dao {
 	struct dao_rsc_ops *ops;	/* DAO specific operations */
 	struct imapper **imappers;
 	struct daio_mgr *mgr;
-	void *hw;
+	struct hw *hw;
 	void *ctrl_blk;
 };
 
 struct dai {
 	struct daio daio;
 	struct dai_rsc_ops *ops;	/* DAI specific operations */
-	void *hw;
+	struct hw *hw;
 	void *ctrl_blk;
 };
 
@@ -117,7 +117,7 @@ struct daio_mgr {
 };
 
 /* Constructor and destructor of daio resource manager */
-int daio_mgr_create(void *hw, struct daio_mgr **rdaio_mgr);
+int daio_mgr_create(struct hw *hw, struct daio_mgr **rdaio_mgr);
 int daio_mgr_destroy(struct daio_mgr *daio_mgr);
 
 #endif /* CTDAIO_H */
diff --git a/sound/pci/ctxfi/ctresource.c b/sound/pci/ctxfi/ctresource.c
index e49d2be..f14cbea 100644
--- a/sound/pci/ctxfi/ctresource.c
+++ b/sound/pci/ctxfi/ctresource.c
@@ -134,7 +134,8 @@ static struct rsc_ops rsc_generic_ops = {
 	.next_conj	= rsc_next_conj,
 };
 
-int rsc_init(struct rsc *rsc, u32 idx, enum RSCTYP type, u32 msr, void *hw)
+int
+rsc_init(struct rsc *rsc, u32 idx, enum RSCTYP type, u32 msr, struct hw *hw)
 {
 	int err = 0;
 
@@ -206,7 +207,7 @@ int rsc_uninit(struct rsc *rsc)
 }
 
 int rsc_mgr_init(struct rsc_mgr *mgr, enum RSCTYP type,
-		 unsigned int amount, void *hw_obj)
+		 unsigned int amount, struct hw *hw_obj)
 {
 	int err = 0;
 	struct hw *hw = hw_obj;
diff --git a/sound/pci/ctxfi/ctresource.h b/sound/pci/ctxfi/ctresource.h
index 0838c2e..9b746c3 100644
--- a/sound/pci/ctxfi/ctresource.h
+++ b/sound/pci/ctxfi/ctresource.h
@@ -38,7 +38,7 @@ struct rsc {
 	u32 conj:12;	/* Current conjugate index */
 	u32 msr:4;	/* The Master Sample Rate a resource working on */
 	void *ctrl_blk;	/* Chip specific control info block for a resource */
-	void *hw;	/* Chip specific object for hardware access means */
+	struct hw *hw;	/* Chip specific object for hardware access means */
 	struct rsc_ops *ops;	/* Generic resource operations */
 };
 
@@ -50,7 +50,8 @@ struct rsc_ops {
 	int (*output_slot)(const struct rsc *rsc);
 };
 
-int rsc_init(struct rsc *rsc, u32 idx, enum RSCTYP type, u32 msr, void *hw);
+int
+rsc_init(struct rsc *rsc, u32 idx, enum RSCTYP type, u32 msr, struct hw *hw);
 int rsc_uninit(struct rsc *rsc);
 
 struct rsc_mgr {
@@ -59,12 +60,12 @@ struct rsc_mgr {
 	unsigned int avail; /* The amount of currently available resources */
 	unsigned char *rscs; /* The bit-map for resource allocation */
 	void *ctrl_blk; /* Chip specific control info block */
-	void *hw; /* Chip specific object for hardware access */
+	struct hw *hw; /* Chip specific object for hardware access */
 };
 
 /* Resource management is based on bit-map mechanism */
 int rsc_mgr_init(struct rsc_mgr *mgr, enum RSCTYP type,
-		 unsigned int amount, void *hw);
+		 unsigned int amount, struct hw *hw);
 int rsc_mgr_uninit(struct rsc_mgr *mgr);
 int mgr_get_resource(struct rsc_mgr *mgr, unsigned int n, unsigned int *ridx);
 int mgr_put_resource(struct rsc_mgr *mgr, unsigned int n, unsigned int idx);
diff --git a/sound/pci/ctxfi/ctsrc.c b/sound/pci/ctxfi/ctsrc.c
index 19df9b4..342008f 100644
--- a/sound/pci/ctxfi/ctsrc.c
+++ b/sound/pci/ctxfi/ctsrc.c
@@ -543,7 +543,7 @@ static int src_mgr_commit_write(struct src_mgr *mgr)
 	return 0;
 }
 
-int src_mgr_create(void *hw, struct src_mgr **rsrc_mgr)
+int src_mgr_create(struct hw *hw, struct src_mgr **rsrc_mgr)
 {
 	int err, i;
 	struct src_mgr *src_mgr;
@@ -825,7 +825,7 @@ static int srcimp_imap_delete(struct srcimp_mgr *mgr, struct imapper *entry)
 	return err;
 }
 
-int srcimp_mgr_create(void *hw, struct srcimp_mgr **rsrcimp_mgr)
+int srcimp_mgr_create(struct hw *hw, struct srcimp_mgr **rsrcimp_mgr)
 {
 	int err;
 	struct srcimp_mgr *srcimp_mgr;
diff --git a/sound/pci/ctxfi/ctsrc.h b/sound/pci/ctxfi/ctsrc.h
index 259366a..6d95afb 100644
--- a/sound/pci/ctxfi/ctsrc.h
+++ b/sound/pci/ctxfi/ctsrc.h
@@ -140,10 +140,10 @@ struct srcimp_mgr {
 };
 
 /* Constructor and destructor of SRC resource manager */
-int src_mgr_create(void *hw, struct src_mgr **rsrc_mgr);
+int src_mgr_create(struct hw *hw, struct src_mgr **rsrc_mgr);
 int src_mgr_destroy(struct src_mgr *src_mgr);
 /* Constructor and destructor of SRCIMP resource manager */
-int srcimp_mgr_create(void *hw, struct srcimp_mgr **rsrc_mgr);
+int srcimp_mgr_create(struct hw *hw, struct srcimp_mgr **rsrc_mgr);
 int srcimp_mgr_destroy(struct srcimp_mgr *srcimp_mgr);
 
 #endif /* CTSRC_H */
-- 
1.8.1.2

