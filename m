Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaGILgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:36:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45164 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaGILgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:45 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-02-53bd294b68a9
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 16/21] arm: boot: compressed: disable kasan's
 instrumentation
Date: Wed, 09 Jul 2014 15:30:10 +0400
Message-id: <1404905415-9046-17-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xy7remnuDDd78ZLfY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsErozn5+czF6xgrZh//i9LA+Mm
	li5GTg4JAROJ3zt/MkPYYhIX7q1n62Lk4hASWMoo8fjDF1YIp49J4vXFI0wgVWwCehL/Zm1n
	A7FFBBQkNvc+AytiFmhmk2jv+MAKkhAWSJA4PfEGO4jNIqAqMWvvUrAVvAJuEhc3HYRapyCx
	bPlMsHpOoPiE6deA4hxA21wlJqxQm8DIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZG
	SCx92cG4+JjVIUYBDkYlHl6N2t3BQqyJZcWVuYcYJTiYlUR4bUX3BgvxpiRWVqUW5ccXleak
	Fh9iZOLglGpgVJsS16tezDktWvVX8XvfFYfyviRN9TU5+va2y9NnxRMmqZ1NLRLjtzgSPZfX
	iG/V2v/GISK7rCK6uxveXdz+vntGd5I9072+x3lv4tI6pp6bOuc9N3vel1WG66QnHBP6Mbn0
	0vXVh5Zc3erUmL1j6tJPddVV029W6708ccz3f+kNZtPpiUdju5RYijMSDbWYi4oTAZ8gVl6D	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid build errors, compiler's instrumentation used for kernel
address sanitizer, must be disabled for code not linked with kernel.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/boot/compressed/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 76a50ec..03f2976 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -4,6 +4,8 @@
 # create a compressed vmlinuz image from the original vmlinux
 #
 
+KASAN_SANITIZE := n
+
 OBJS		=
 
 # Ensure that MMCIF loader code appears early in the image
-- 
1.8.5.5

