Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbaBEUsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:48:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:55031 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaBEUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 110/213] x86, tls: Off by one limit check
Date: Wed, 5 Feb 2014 15:01:05 -0500
Message-ID: <1391630568-49251-111-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8f0750f19789cf352d7e24a6cc50f2ab1b4f1372 upstream.

These are used as offsets into an array of GDT_ENTRY_TLS_ENTRIES members
so GDT_ENTRY_TLS_ENTRIES is one past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/20120324075250.GA28258@elgon.mountain
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/tls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b8579e70..bcfec2d23769 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -163,7 +163,7 @@ int regset_tls_get(struct task_struct *target, const struct user_regset *regset,
 {
 	const struct desc_struct *tls;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
@@ -198,7 +198,7 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
-- 
1.8.5.2

