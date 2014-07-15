Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbaGOJMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:12:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50941 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaGOJMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:12:18 -0400
Message-ID: <53C4F06F.2090204@gmail.com>
Date: Tue, 15 Jul 2014 11:12:15 +0200
From: Klemen Jan Enova <klemen.jan.enova@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: sortextable: change type and initialise variable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the type of 'relocs_size' from 'int' to 'Elf32_Word' and 
initialize it to 0, to fix the "maybe uninitialised variable" compiler 
warning.

Signed-off-by: Klemen Jan Enova <klemen.jan.enova@gmail.com>
---
diff --git a/scripts/sortextable.h b/scripts/sortextable.h
index 8fac3fd..537858d 100644
--- a/scripts/sortextable.h
+++ b/scripts/sortextable.h
@@ -103,7 +103,7 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, 
table_sort_
         Elf_Sym *sort_needed_sym;
         Elf_Shdr *sort_needed_sec;
         Elf_Rel *relocs = NULL;
-       int relocs_size;
+       Elf32_Word relocs_size = 0;
         uint32_t *sort_done_location;
         const char *secstrtab;
         const char *strtab;
