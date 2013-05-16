Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3EPLSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:18:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab3EPLSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:18:39 -0400
Date: Thu, 16 May 2013 14:15:48 +0300
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
Subject: [PATCH v2 08/10] tile: uaccess s/might_sleep/might_fault/
Message-ID: <018bba1e097552bc4054e6d90e3f03e7c9a632bb.1368702323.git.mst@redhat.com>
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
 arch/tile/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index 8a082bc..e4d44bd 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -442,7 +442,7 @@ extern unsigned long __copy_in_user_inatomic(
 static inline unsigned long __must_check
 __copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	return __copy_in_user_inatomic(to, from, n);
 }
 
-- 
MST

