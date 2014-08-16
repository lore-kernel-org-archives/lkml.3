Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaHPB1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 21:27:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaHPB1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 21:27:00 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, Baoquan He <bhe@redhat.com>
Subject: [PATCH] kexec: remove the unused function parameter
Date: Sat, 16 Aug 2014 09:25:34 +0800
Message-Id: <1408152334-27678-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup. In function parse_crashkernel_suffix, the
parameter crash_base is not used. So here remove it.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 kernel/kexec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 0b49a0a..7c3e72a 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1750,7 +1750,6 @@ static __initdata char *suffix_tbl[] = {
  */
 static int __init parse_crashkernel_suffix(char *cmdline,
 					   unsigned long long	*crash_size,
-					   unsigned long long	*crash_base,
 					   const char *suffix)
 {
 	char *cur = cmdline;
@@ -1839,7 +1838,7 @@ static int __init __parse_crashkernel(char *cmdline,
 
 	if (suffix)
 		return parse_crashkernel_suffix(ck_cmdline, crash_size,
-				crash_base, suffix);
+				suffix);
 	/*
 	 * if the commandline contains a ':', then that's the extended
 	 * syntax -- if not, it must be the classic syntax
-- 
1.8.5.3

