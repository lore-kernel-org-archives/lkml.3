Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbaISPaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:30:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:49352 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738AbaISPaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:30:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="605437220"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: sparse@chrisli.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>,
        Brian Norris <computersforpeace@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5/7] signal: Silence nested-externs warnings
Date: Fri, 19 Sep 2014 08:29:38 -0700
Message-Id: <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Silence nested-externs warnings for these, as these nested
externs are truly wanted.

CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Richard Weinberger <richard@nod.at>
CC: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/signal.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 750196f..e68ae6b 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -67,7 +67,9 @@ static inline int sigismember(sigset_t *set, int _sig)
 
 static inline int sigisemptyset(sigset_t *set)
 {
+	DIAG_PUSH DIAG_IGNORE(nested-externs)
 	extern void _NSIG_WORDS_is_unsupported_size(void);
+	DIAG_POP
 	switch (_NSIG_WORDS) {
 	case 4:
 		return (set->sig[3] | set->sig[2] |
@@ -90,7 +92,9 @@ static inline int sigisemptyset(sigset_t *set)
 #define _SIG_SET_BINOP(name, op)					\
 static inline void name(sigset_t *r, const sigset_t *a, const sigset_t *b) \
 {									\
+	DIAG_PUSH DIAG_IGNORE(nested-externs)				\
 	extern void _NSIG_WORDS_is_unsupported_size(void);		\
+	DIAG_POP							\
 	unsigned long a0, a1, a2, a3, b0, b1, b2, b3;			\
 									\
 	switch (_NSIG_WORDS) {						\
@@ -128,7 +132,9 @@ _SIG_SET_BINOP(sigandnsets, _sig_andn)
 #define _SIG_SET_OP(name, op)						\
 static inline void name(sigset_t *set)					\
 {									\
+	DIAG_PUSH DIAG_IGNORE(nested-externs)				\
 	extern void _NSIG_WORDS_is_unsupported_size(void);		\
+	DIAG_POP							\
 									\
 	switch (_NSIG_WORDS) {						\
 	    case 4: set->sig[3] = op(set->sig[3]);			\
-- 
1.9.3

