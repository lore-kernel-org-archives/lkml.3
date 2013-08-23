Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3HWPQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:16:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab3HWPQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:16:48 -0400
Message-ID: <1377271002.7359.2.camel@deneb.redhat.com>
Subject: [PATCH] arm64: move elf notes into readonly segment
From: Mark Salter <msalter@redhat.com>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 23 Aug 2013 11:16:42 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current vmlinux.lds.S places the notes sections between the
end of rw data and start of bss. This means that _edata doesn't
really point to the end of data. Since notes are read-only, this
patch moves them to the read-only segment so that _edata does
point to the end of initialized rw data.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/kernel/vmlinux.lds.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index f5e5574..f8ab9d8 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -71,6 +71,7 @@ SECTIONS
 
 	RO_DATA(PAGE_SIZE)
 	EXCEPTION_TABLE(8)
+	NOTES
 	_etext = .;			/* End of text and rodata section */
 
 	. = ALIGN(PAGE_SIZE);
@@ -122,8 +123,6 @@ SECTIONS
 	}
 	_edata_loc = __data_loc + SIZEOF(.data);
 
-	NOTES
-
 	BSS_SECTION(0, 0, 0)
 	_end = .;
 
-- 
1.8.3.1



