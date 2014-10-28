Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbaJ1LPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:15:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaJ1LPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:15:32 -0400
Date: Tue, 28 Oct 2014 04:15:22 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-9c0080ef93bce34db130db6dc3bd946348e6a203@git.kernel.org>
Cc: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, hpa@zytor.com
Reply-To: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, luto@amacapital.net
In-Reply-To: <ac63814ca4c637a08ec2fd0360d67ca67560a9ee.1411494540.git.luto@amacapital.net>
References: <ac63814ca4c637a08ec2fd0360d67ca67560a9ee.1411494540.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso:
  Make the PER_CPU segment start out accessed
Git-Commit-ID: 9c0080ef93bce34db130db6dc3bd946348e6a203
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

Commit-ID:  9c0080ef93bce34db130db6dc3bd946348e6a203
Gitweb:     http://git.kernel.org/tip/9c0080ef93bce34db130db6dc3bd946348e6a203
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 23 Sep 2014 10:50:54 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:22:11 +0100

x86/vdso: Make the PER_CPU segment start out accessed

The first userspace attempt to read or write the PER_CPU segment
will write the accessed bit to the GDT.  This is visible to
userspace using the LAR instruction, and it also pointlessly
dirties a cache line.

Set the segment's accessed bit at boot to prevent userspace
access to segments from having side effects.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/ac63814ca4c637a08ec2fd0360d67ca67560a9ee.1411494540.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/vdso/vma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 261b134..0c799746 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -264,7 +264,7 @@ static void vsyscall_set_cpu(int cpu)
 	d = (struct desc_struct) {
 		.limit0 = cpu | ((node & 0xf) << 12),
 		.limit = node >> 4,
-		.type = 4,		/* RO data, expand down */
+		.type = 5,		/* RO data, expand down, accessed */
 		.dpl = 3,		/* Visible to user code */
 		.s = 1,			/* Not a system segment */
 		.p = 1,			/* Present */
