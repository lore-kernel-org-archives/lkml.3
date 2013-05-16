Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3EPLL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:11:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3EPLLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:11:55 -0400
Date: Thu, 16 May 2013 14:10:14 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        microblaze-uclinux@itee.uq.edu.au, linux-am33-list@redhat.com,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org
Subject: [PATCH v2 02/10] arm64: uaccess s/might_sleep/might_fault/
Message-ID: <90a2283bb84b6ce77c9966d76dbceb5c7edffd18.1368702323.git.mst@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368702323.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/arm64/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 008f848..edb3d5c 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -166,7 +166,7 @@ do {									\
 
 #define get_user(x, ptr)						\
 ({									\
-	might_sleep();							\
+	might_fault();							\
 	access_ok(VERIFY_READ, (ptr), sizeof(*(ptr))) ?			\
 		__get_user((x), (ptr)) :				\
 		((x) = 0, -EFAULT);					\
@@ -227,7 +227,7 @@ do {									\
 
 #define put_user(x, ptr)						\
 ({									\
-	might_sleep();							\
+	might_fault();							\
 	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr))) ?		\
 		__put_user((x), (ptr)) :				\
 		-EFAULT;						\
-- 
MST

