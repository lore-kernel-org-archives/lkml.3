Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab3JCOAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:00:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3JCOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:00:11 -0400
Date: Thu, 3 Oct 2013 06:59:33 -0700
From: tip-bot for Tom Gundersen <tipbot@zytor.com>
Message-ID: <tip-e33a29a5ae711162c6b6fefc0a2ef18f4a4254bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, swarren@wwwdotorg.org, hpa@zytor.com,
        mingo@kernel.org, swarren@nvidia.com, geert@linux-m68k.org,
        tglx@linutronix.de, teg@jklm.no, dh.herrmann@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, swarren@nvidia.com, geert@linux-m68k.org,
        tglx@linutronix.de, teg@jklm.no, dh.herrmann@gmail.com
In-Reply-To: <1380644320-1026-1-git-send-email-teg@jklm.no>
References: <1380644320-1026-1-git-send-email-teg@jklm.no>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/simplefb:
  Fix overflow causing bogus fall-back
Git-Commit-ID: e33a29a5ae711162c6b6fefc0a2ef18f4a4254bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 03 Oct 2013 06:59:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e33a29a5ae711162c6b6fefc0a2ef18f4a4254bf
Gitweb:     http://git.kernel.org/tip/e33a29a5ae711162c6b6fefc0a2ef18f4a4254bf
Author:     Tom Gundersen <teg@jklm.no>
AuthorDate: Tue, 1 Oct 2013 18:18:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 2 Oct 2013 07:50:40 +0200

x86/simplefb: Fix overflow causing bogus fall-back

On my MacBook Air lfb_size is 4M, which makes the bitshit
overflow (to 256GB - larger than 32 bits), meaning we fall
back to efifb unnecessarily.

Cast to u64 to avoid the overflow.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Link: http://lkml.kernel.org/r/1380644320-1026-1-git-send-email-teg@jklm.no
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/sysfb_simplefb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 22513e9..4ebd636 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -72,7 +72,7 @@ __init int create_simplefb(const struct screen_info *si,
 	 * the part that is occupied by the framebuffer */
 	len = mode->height * mode->stride;
 	len = PAGE_ALIGN(len);
-	if (len > si->lfb_size << 16) {
+	if (len > (u64)si->lfb_size << 16) {
 		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
 		return -EINVAL;
 	}
