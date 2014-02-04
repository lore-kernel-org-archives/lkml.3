Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718AbaBDVf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:35:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934567AbaBDVMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Arnez <arnez@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.13 068/140] s390/compat: fix PSW32_USER_BITS definition
Date: Tue,  4 Feb 2014 13:10:55 -0800
Message-Id: <20140204211038.901488093@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 075dfd82102d2048e43e1cbf48d558d915c50072 upstream.

PSW32_USER_BITS should define the primary address space for user space
instead of the home address space.
Symptom of this bug is that gdb doesn't work in compat mode.

The bug was introduced with e258d719ff28 "s390/uaccess: always run the kernel
in home space" and f26946d7ecad "s390/compat: make psw32_user_bits a constant
value again".

Reported-by: Andreas Arnez <arnez@linux.vnet.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/compat.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -38,7 +38,8 @@
 
 #define PSW32_USER_BITS (PSW32_MASK_DAT | PSW32_MASK_IO | PSW32_MASK_EXT | \
 			 PSW32_DEFAULT_KEY | PSW32_MASK_BASE | \
-			 PSW32_MASK_MCHECK | PSW32_MASK_PSTATE | PSW32_ASC_HOME)
+			 PSW32_MASK_MCHECK | PSW32_MASK_PSTATE | \
+			 PSW32_ASC_PRIMARY)
 
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"s390\0\0\0\0"


