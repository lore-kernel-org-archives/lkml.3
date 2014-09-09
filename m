Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbaIILiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194AbaIILiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:38:07 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, vgoyal@redhat.com, ebiederm@xmission.com,
        tglx@linutronix.de, mingo@redhat.com, Baoquan He <bhe@redhat.com>
Subject: [Patch v2 3/3] kexec: remove the unused function parameter
Date: Tue,  9 Sep 2014 19:36:20 +0800
Message-Id: <1410262580-1561-3-git-send-email-bhe@redhat.com>
In-Reply-To: <1410262580-1561-1-git-send-email-bhe@redhat.com>
References: <1410262580-1561-1-git-send-email-bhe@redhat.com>
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
index 63bc3cd..2abf9f6 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1759,7 +1759,6 @@ static __initdata char *suffix_tbl[] = {
  */
 static int __init parse_crashkernel_suffix(char *cmdline,
 					   unsigned long long	*crash_size,
-					   unsigned long long	*crash_base,
 					   const char *suffix)
 {
 	char *cur = cmdline;
@@ -1848,7 +1847,7 @@ static int __init __parse_crashkernel(char *cmdline,
 
 	if (suffix)
 		return parse_crashkernel_suffix(ck_cmdline, crash_size,
-				crash_base, suffix);
+				suffix);
 	/*
 	 * if the commandline contains a ':', then that's the extended
 	 * syntax -- if not, it must be the classic syntax
-- 
1.8.5.3

