Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaGBWlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:41:09 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32797 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaGBWlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:41:07 -0400
MIME-Version: 1.0
From: enh <enh@google.com>
Date: Wed, 2 Jul 2014 15:40:45 -0700
Message-ID: <CAJgzZoqDjzBfTcAh143ZVX6cQaqRXJcFwiOhgZt32a8DVJeqwQ@mail.gmail.com>
Subject: [PATCH] Elf32_Dyn::d_val should be an Elf32_Word.
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ELF specification says that d_val is an Elf32_Word, not an Elf32_Sword.
This also matches glibc, and fixes bionic (Android's C library, which uses
the uapi header).

Patch is against -rc ToT.

Signed-off-by: Elliott Hughes <enh@google.com>
---
 include/uapi/linux/elf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ef6103b..d7878dc 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -137,7 +137,7 @@ typedef __s64 Elf64_Sxword;
 typedef struct dynamic{
   Elf32_Sword d_tag;
   union{
-    Elf32_Sword d_val;
+    Elf32_Word d_val;
     Elf32_Addr d_ptr;
   } d_un;
 } Elf32_Dyn;
-- 
2.0.0.526.g5318336
