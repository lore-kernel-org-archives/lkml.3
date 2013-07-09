Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3GIRNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:13:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45397 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751644Ab3GIRNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:13:05 -0400
Message-ID: <1373389983.14604.18.camel@joe-AO722>
Subject: ia64: dmi.h: Make dmi_alloc use kzalloc
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64 <linux-ia64@vger.kernel.org>
Date: Tue, 09 Jul 2013 10:13:03 -0700
In-Reply-To: <1373386794.14604.14.camel@joe-AO722>
References: <1373384438.4391.6.camel@chaos.site>
	 <1373384574.4391.9.camel@chaos.site> <1373386794.14604.14.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86/ia64 have a slight mismatch in dmi_alloc as
x86 does a memset(0), and ia64 just does kmalloc.

Make the ia64 dmi_alloc match the x86 style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ia64/include/asm/dmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/dmi.h b/arch/ia64/include/asm/dmi.h
index 1ed4c8f..185d3d1 100644
--- a/arch/ia64/include/asm/dmi.h
+++ b/arch/ia64/include/asm/dmi.h
@@ -7,6 +7,6 @@
 /* Use normal IO mappings for DMI */
 #define dmi_ioremap ioremap
 #define dmi_iounmap(x,l) iounmap(x)
-#define dmi_alloc(l) kmalloc(l, GFP_ATOMIC)
+#define dmi_alloc(l) kzalloc(l, GFP_ATOMIC)
 
 #endif


