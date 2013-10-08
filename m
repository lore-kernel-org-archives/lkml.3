Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3JHTEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:04:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3JHTEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:04:30 -0400
Date: Tue, 8 Oct 2013 12:03:43 -0700
From: tip-bot for Andre Richter <tipbot@zytor.com>
Message-ID: <tip-122498738417c73943b71294c60ec34fc110f5d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, andre.o.richter@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, andre.o.richter@gmail.com
In-Reply-To: <1381224142-3267-1-git-send-email-andre.o.richter@gmail.com>
References: <1381224142-3267-1-git-send-email-andre.o.richter@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, msr: Use file_inode(), not f_mapping->
 host
Git-Commit-ID: 122498738417c73943b71294c60ec34fc110f5d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 08 Oct 2013 12:03:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  122498738417c73943b71294c60ec34fc110f5d6
Gitweb:     http://git.kernel.org/tip/122498738417c73943b71294c60ec34fc110f5d6
Author:     Andre Richter <andre.o.richter@gmail.com>
AuthorDate: Tue, 8 Oct 2013 11:22:22 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 Oct 2013 12:01:29 -0700

x86, msr: Use file_inode(), not f_mapping->host

As discussed in [1], exchange f_mapping->host with file_inode().  This
is a bug, but happens to be non-manifest in this case.

[1] http://lkml.kernel.org/r/20131007190357.GA13318@ZenIV.linux.org.uk

Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
Link: http://lkml.kernel.org/r/1381224142-3267-1-git-send-email-andre.o.richter@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
