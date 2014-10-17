Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaJQUrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:47:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaJQUri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:47:38 -0400
Date: Fri, 17 Oct 2014 13:47:27 -0700
From: tip-bot for Fabian Frederick <tipbot@zytor.com>
Message-ID: <tip-03452d27c6cd9cebb59a6bb0fb6bd8557916c263@git.kernel.org>
Cc: hpa@linux.intel.com, fabf@skynet.be, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Reply-To: hpa@zytor.com, mingo@kernel.org, hpa@linux.intel.com, fabf@skynet.be,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1413576120-27147-1-git-send-email-fabf@skynet.be>
References: <1413576120-27147-1-git-send-email-fabf@skynet.be>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, msr:
  Use seek definitions instead of hard-coded values
Git-Commit-ID: 03452d27c6cd9cebb59a6bb0fb6bd8557916c263
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03452d27c6cd9cebb59a6bb0fb6bd8557916c263
Gitweb:     http://git.kernel.org/tip/03452d27c6cd9cebb59a6bb0fb6bd8557916c263
Author:     Fabian Frederick <fabf@skynet.be>
AuthorDate: Fri, 17 Oct 2014 22:01:59 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Oct 2014 13:40:55 -0700

x86, msr: Use seek definitions instead of hard-coded values

Replace 0/1 by SEEK_SET/SEEK_CUR.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Link: http://lkml.kernel.org/r/1413576120-27147-1-git-send-email-fabf@skynet.be
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/msr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 826c8b0..113e707 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -52,11 +52,11 @@ static loff_t msr_seek(struct file *file, loff_t offset, int orig)
 
 	mutex_lock(&inode->i_mutex);
 	switch (orig) {
-	case 0:
+	case SEEK_SET:
 		file->f_pos = offset;
 		ret = file->f_pos;
 		break;
-	case 1:
+	case SEEK_CUR:
 		file->f_pos += offset;
 		ret = file->f_pos;
 		break;
