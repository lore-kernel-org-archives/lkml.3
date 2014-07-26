Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaGZOAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:00:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63206 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaGZOAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:00:06 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: s390: kernel: ipl.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:01:31 +0200
Message-Id: <1406383291-1310-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/s390/kernel/ipl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 633ca75..405367b 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -226,7 +226,7 @@ static ssize_t sys_##_prefix##_##_name##_store(struct kobject *kobj,	\
 		struct kobj_attribute *attr,				\
 		const char *buf, size_t len)				\
 {									\
-	strncpy(_value, buf, sizeof(_value) - 1);			\
+	strlcpy(_value, buf, sizeof(_value));				\
 	strim(_value);							\
 	return len;							\
 }									\
@@ -1959,7 +1959,7 @@ void __init setup_ipl(void)
 		ipl_info.data.fcp.lun = IPL_PARMBLOCK_START->ipl_info.fcp.lun;
 		break;
 	case IPL_TYPE_NSS:
-		strncpy(ipl_info.data.nss.name, kernel_nss_name,
+		strlcpy(ipl_info.data.nss.name, kernel_nss_name,
 			sizeof(ipl_info.data.nss.name));
 		break;
 	case IPL_TYPE_UNKNOWN:
-- 
1.7.10.4

