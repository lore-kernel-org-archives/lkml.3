Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbaJXStE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:49:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbaJXStC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:49:02 -0400
Message-ID: <544A9F1A.4050303@suse.com>
Date: Fri, 24 Oct 2014 14:48:58 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH] vdso: don't require 64-bit math in standalone test
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of 64-bit math on i386 causes build failures:
vdso_standalone_test_x86.c:(.text+0x101): undefined reference to `__umoddi3'
vdso_standalone_test_x86.c:(.text+0x12d): undefined reference to `__udivdi3'

Commit adb19fb66ee (Documentation: add makefiles for more targets) is
now building this by default, so it's failing the kernel build entirely.

Switching the declaration from uint64_t to time_t does the right thing
and handles the x32 case automatically.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Documentation/vDSO/vdso_standalone_test_x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/vDSO/vdso_standalone_test_x86.c
+++ b/Documentation/vDSO/vdso_standalone_test_x86.c
@@ -63,7 +63,7 @@ static inline void linux_exit(int code)
 	x86_syscall3(__NR_exit, code, 0, 0);
 }
 
-void to_base10(char *lastdig, uint64_t n)
+void to_base10(char *lastdig, time_t n)
 {
 	while (n) {
 		*lastdig = (n % 10) + '0';

-- 
Jeff Mahoney
SUSE Labs
