Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3DZRUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:20:43 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:56716 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3DZRUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:20:41 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: matt.fleming@intel.com, mjg59@srcf.ucam.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86, efi: initial the local variable of DataSize to zero
Date: Sat, 27 Apr 2013 01:19:27 +0800
Message-Id: <1366996767-8234-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That will be better initial the value of DataSize to zero for the input of
GetVariable(), otherwise we will feed a random value. The debug log of input
DataSize like this:

...
[  195.915612] EFI Variables Facility v0.08 2004-May-17
[  195.915819] efi: size: 18446744071581821342
[  195.915969] efi:  size': 18446744071581821342
[  195.916324] efi: size: 18446612150714306560
[  195.916632] efi:  size': 18446612150714306560
[  195.917159] efi: size: 18446612150714306560
[  195.917453] efi:  size': 18446612150714306560
...

Found on Acer Aspire V3 BIOS, it will not return the size of data if we input a
non-zero DataSize.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/platform/efi/efi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e4a86a6..cb59732 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -204,7 +204,7 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 	}
 
 	if (boot_used_size && !finished) {
-		unsigned long size;
+		unsigned long size = 0;
 		u32 attr;
 		efi_status_t s;
 		void *tmp;
-- 
1.6.0.2

