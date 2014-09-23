Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaIWLBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:01:03 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64708 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaIWLBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:01:01 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/5] ALSA: ctxfi: added reference of snd_card
Date: Tue, 23 Sep 2014 16:30:20 +0530
Message-Id: <1411470024-25244-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added a pointer of snd_card in some of the structures to get a
reference of the card from other functions.
these references of snd_card will be initialised in the next patch
of this series and as of now these snd_card will be used to print the
the device information when we convert the pr_* macros to dev_* in a
later patch of this series.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctamixer.h   | 3 +++
 sound/pci/ctxfi/ctdaio.h     | 2 ++
 sound/pci/ctxfi/cthardware.h | 2 ++
 sound/pci/ctxfi/ctsrc.h      | 3 +++
 4 files changed, 10 insertions(+)

diff --git a/sound/pci/ctxfi/ctamixer.h b/sound/pci/ctxfi/ctamixer.h
index cc49e5a..ea81b8a 100644
--- a/sound/pci/ctxfi/ctamixer.h
+++ b/sound/pci/ctxfi/ctamixer.h
@@ -21,6 +21,7 @@
 
 #include "ctresource.h"
 #include <linux/spinlock.h>
+#include <sound/core.h>
 
 /* Define the descriptor of a summation node resource */
 struct sum {
@@ -35,6 +36,7 @@ struct sum_desc {
 
 struct sum_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 
 	 /* request one sum resource */
@@ -79,6 +81,7 @@ struct amixer_desc {
 
 struct amixer_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 
 	 /* request one amixer resource */
diff --git a/sound/pci/ctxfi/ctdaio.h b/sound/pci/ctxfi/ctdaio.h
index 85ccb6e..19cb285 100644
--- a/sound/pci/ctxfi/ctdaio.h
+++ b/sound/pci/ctxfi/ctdaio.h
@@ -23,6 +23,7 @@
 #include "ctimap.h"
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <sound/core.h>
 
 /* Define the descriptor of a daio resource */
 enum DAIOTYP {
@@ -98,6 +99,7 @@ struct daio_desc {
 
 struct daio_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 	spinlock_t imap_lock;
 	struct list_head imappers;
diff --git a/sound/pci/ctxfi/cthardware.h b/sound/pci/ctxfi/cthardware.h
index 5977e9a..940bbd0 100644
--- a/sound/pci/ctxfi/cthardware.h
+++ b/sound/pci/ctxfi/cthardware.h
@@ -20,6 +20,7 @@
 
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <sound/core.h>
 
 enum CHIPTYP {
 	ATC20K1,
@@ -184,6 +185,7 @@ struct hw {
 	void *irq_callback_data;
 
 	struct pci_dev *pci;	/* the pci kernel structure of this card */
+	struct snd_card *card; /* pointer to this card */
 	int irq;
 	unsigned long io_base;
 	unsigned long mem_base;
diff --git a/sound/pci/ctxfi/ctsrc.h b/sound/pci/ctxfi/ctsrc.h
index 259366a..7887cc6 100644
--- a/sound/pci/ctxfi/ctsrc.h
+++ b/sound/pci/ctxfi/ctsrc.h
@@ -23,6 +23,7 @@
 #include "ctimap.h"
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <sound/core.h>
 
 #define SRC_STATE_OFF	0x0
 #define SRC_STATE_INIT	0x4
@@ -85,6 +86,7 @@ struct src_desc {
 /* Define src manager object */
 struct src_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 
 	 /* request src resource */
@@ -123,6 +125,7 @@ struct srcimp_desc {
 
 struct srcimp_mgr {
 	struct rsc_mgr mgr;	/* Basic resource manager info */
+	struct snd_card *card;	/* pointer to this card */
 	spinlock_t mgr_lock;
 	spinlock_t imap_lock;
 	struct list_head imappers;
-- 
1.8.1.2

