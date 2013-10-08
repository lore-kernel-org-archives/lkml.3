Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3JHJXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:23:12 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:50160 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3JHJXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:23:10 -0400
From: Andre Richter <andre.o.richter@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andre Richter <andre.o.richter@gmail.com>
Subject: [PATCH 1/1] arch/x86/kernel/msr.c: Add another file_inode()
Date: Tue,  8 Oct 2013 11:22:22 +0200
Message-Id: <1381224142-3267-1-git-send-email-andre.o.richter@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in [1], exchange f_mapping->host with file_inode().

[1] https://lkml.org/lkml/2013/10/7/499

Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
---
 arch/x86/kernel/msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 88458fa..05266b5 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -46,7 +46,7 @@ static struct class *msr_class;
 static loff_t msr_seek(struct file *file, loff_t offset, int orig)
 {
 	loff_t ret;
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = file_inode(file);
 
 	mutex_lock(&inode->i_mutex);
 	switch (orig) {
-- 
1.8.1.2

