Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab3IDGNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:13:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761955Ab3IDGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:13:18 -0400
Date: Tue, 3 Sep 2013 23:13:01 -0700
From: tip-bot for Yanchuan Nian <tipbot@zytor.com>
Message-ID: <tip-7752572f18f98ee796e173334b088a1d621d2da4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ycnian@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ycnian@gmail.com, tglx@linutronix.de
In-Reply-To: <1378257924-29446-1-git-send-email-ycnian@gmail.com>
References: <1378257924-29446-1-git-send-email-ycnian@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86/irq:
  Correct comment about i8259 initialization
Git-Commit-ID: 7752572f18f98ee796e173334b088a1d621d2da4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 23:13:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7752572f18f98ee796e173334b088a1d621d2da4
Gitweb:     http://git.kernel.org/tip/7752572f18f98ee796e173334b088a1d621d2da4
Author:     Yanchuan Nian <ycnian@gmail.com>
AuthorDate: Wed, 4 Sep 2013 09:25:24 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 4 Sep 2013 07:46:04 +0200

x86/irq: Correct comment about i8259 initialization

0x30-0x3f have been used for ISA interrupts on i386 as well
since 5 years ago, but old comments about i8259 initialization
were still referring to the old i386 usage of this port range.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
Cc: yinghai@kernel.org
Cc: pavel@suse.cz
Link: http://lkml.kernel.org/r/1378257924-29446-1-git-send-email-ycnian@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/i8259.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 9a5c460..2e977b5 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -312,8 +312,7 @@ static void init_8259A(int auto_eoi)
 	 */
 	outb_pic(0x11, PIC_MASTER_CMD);	/* ICW1: select 8259A-1 init */
 
-	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 on x86-64,
-	   to 0x20-0x27 on i386 */
+	/* ICW2: 8259A-1 IR0-7 mapped to 0x30-0x37 */
 	outb_pic(IRQ0_VECTOR, PIC_MASTER_IMR);
 
 	/* 8259A-1 (the master) has a slave on IR2 */
