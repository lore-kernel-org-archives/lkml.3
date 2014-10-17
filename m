Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaJQUCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:02:07 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:1108 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbaJQUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:02:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwSAJR0QVRXQz/c/2dsb2JhbABbgw6BK7hjAQEBAQEBBQFzmicEAoEVFwF9hDAvI4EaN4hDAb9Gjl0shiKKKx2ENQWdWZYlgUcBbIFFOy+CSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: [PATCH 4/4 linux-next] x86, msr: use seek definitions instead of hard-coded values
Date: Fri, 17 Oct 2014 22:01:59 +0200
Message-Id: <1413576120-27147-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace 0/1 by SEEK_SET/SEEK_CUR.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/kernel/msr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 1c66cd0..1ed1190 100644
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
-- 
1.9.3

