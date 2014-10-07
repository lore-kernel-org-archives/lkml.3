Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaJGU0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:26:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:57293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaJGU0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:26:22 -0400
Message-ID: <1412713571.32313.132.camel@smoke>
Subject: Re: [PATCH V3 4/5] kexec: Add IND_FLAGS macro
From: Geoff Levand <geoff@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 13:26:11 -0700
In-Reply-To: <de975a34c5beb9715359eaa4d74ba82a7798aae3.1412640584.git.geoff@infradead.org>
References: <cover.1412640584.git.geoff@infradead.org>
	 <de975a34c5beb9715359eaa4d74ba82a7798aae3.1412640584.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new kexec preprocessor macro IND_FLAGS, which is the bitwise OR of
all the possible kexec IND_ kimage_entry indirection flags.  Having this
macro allows for simplified code in the prosessing of the kexec
kimage_entry items.  Also, remove the local powerpc definition and use
the generic one.

Signed-off-by: Geoff Levand <geoff@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

>From V2: Folded patch 5 into patch 4.

 arch/powerpc/kernel/machine_kexec_64.c | 2 --
 include/linux/kexec.h                  | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 879b3aa..75652a32 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -96,8 +96,6 @@ int default_machine_kexec_prepare(struct kimage *image)
 	return 0;
 }
 
-#define IND_FLAGS (IND_DESTINATION | IND_INDIRECTION | IND_DONE | IND_SOURCE)
-
 static void copy_segments(unsigned long ind)
 {
 	unsigned long entry;
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 8c628ca..a4758f9 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -10,6 +10,7 @@
 #define IND_INDIRECTION  (1 << IND_INDIRECTION_BIT)
 #define IND_DONE         (1 << IND_DONE_BIT)
 #define IND_SOURCE       (1 << IND_SOURCE_BIT)
+#define IND_FLAGS (IND_DESTINATION | IND_INDIRECTION | IND_DONE | IND_SOURCE)
 
 #if !defined(__ASSEMBLY__)
 
-- 
1.9.1



