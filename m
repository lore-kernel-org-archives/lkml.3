Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3HFVNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:13:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41372 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213Ab3HFVN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:13:29 -0400
X-Sasl-enc: dIjryLR0gAPllMNbNdth7VeLT1Fu2HOvD8nsWE369Ewt 1375823606
From: Christoph Jaeger <christophjaeger@linux.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH 1/1] module: fix sprintf format specifier in param_get_byte()
Date: Tue,  6 Aug 2013 23:12:12 +0200
Message-Id: <1375823532-24153-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In param_get_byte(), to which the macro STANDARD_PARAM_DEF(byte, ...) expands,
"%c" is used to print an unsigned char. So it gets printed as a character what
is not intended here. Use "%hhu" instead.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 kernel/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
index 440e65d..59f7ac7 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -252,7 +252,7 @@ int parse_args(const char *doing,
 	EXPORT_SYMBOL(param_ops_##name)
 
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, strict_strtoul);
 STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
 STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
 STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
-- 
1.8.3.1

