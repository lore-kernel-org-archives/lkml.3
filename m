Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaIZSrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:47:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32010 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941AbaIZSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:47:05 -0400
From: Josef Bacik <jbacik@fb.com>
To: <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: use pr_stat for version output
Date: Fri, 26 Sep 2014 14:47:00 -0400
Message-ID: <1411757220-29334-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-26_07:2014-09-26,2014-09-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.14650560951213e-13 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409260178
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows tools linking against the trace-cmd libraries to supress this output
if it is not necessary for them.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/trace-input.c b/trace-input.c
index 8118b22..090ee59 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -2237,7 +2237,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	version = read_string(handle);
 	if (!version)
 		goto failed_read;
-	printf("version = %s\n", version);
+	pr_stat("version = %s\n", version);
 	free(version);
 
 	if (do_read_check(handle, buf, 1))
-- 
1.9.3

