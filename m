Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaAVMZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:25:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59125 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaAVMZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:25:45 -0500
Date: Wed, 22 Jan 2014 04:25:34 -0800
From: tip-bot for David Woodhouse <tipbot@zytor.com>
Message-ID: <tip-9b3965f7401b0cc3ed2c228085a4c13b1c9243b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, David.Woodhouse@intel.com
In-Reply-To: <1389180083-23249-2-git-send-email-David.Woodhouse@intel.com>
References: <1389180083-23249-2-git-send-email-David.Woodhouse@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, boot: Use __attribute__((used))
  to ensure videocard structs are emitted
Git-Commit-ID: 9b3965f7401b0cc3ed2c228085a4c13b1c9243b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 22 Jan 2014 04:25:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b3965f7401b0cc3ed2c228085a4c13b1c9243b1
Gitweb:     http://git.kernel.org/tip/9b3965f7401b0cc3ed2c228085a4c13b1c9243b1
Author:     David Woodhouse <David.Woodhouse@intel.com>
AuthorDate: Wed, 8 Jan 2014 11:21:21 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Jan 2014 04:21:45 -0800

x86, boot: Use __attribute__((used)) to ensure videocard structs are emitted

It looks like GCC will always emit an object that is marked with an
explicit section, although the documentation doesn't say that and we
possibly shouldn't be relying on it.

Clang does *not* do so, so add __attribute__((used)) to make sure.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1389180083-23249-2-git-send-email-David.Woodhouse@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/video.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/video.h b/arch/x86/boot/video.h
index ff339c5..0bb2549 100644
--- a/arch/x86/boot/video.h
+++ b/arch/x86/boot/video.h
@@ -80,7 +80,7 @@ struct card_info {
 	u16 xmode_n;		/* Size of unprobed mode range */
 };
 
-#define __videocard struct card_info __attribute__((section(".videocards")))
+#define __videocard struct card_info __attribute__((used,section(".videocards")))
 extern struct card_info video_cards[], video_cards_end[];
 
 int mode_defined(u16 mode);	/* video.c */
