Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab3E1DzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52538 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758843Ab3E1DyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Richard Weinberger" <richard@nod.at>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.441311212@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [94/94] um: Serve io_remap_pfn_range()
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 4d94d6d030adfdea4837694d293ec6918d133ab2 upstream.

At some places io_remap_pfn_range() is needed.
UML has to serve it like all other archs do.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/um/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -69,6 +69,8 @@ extern unsigned long end_iomem;
 #define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
 
+#define io_remap_pfn_range	remap_pfn_range
+
 /*
  * The i386 can't do page protection for execute, and considers that the same
  * are read.

