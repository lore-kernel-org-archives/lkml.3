Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbaCZS5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:57:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3472 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbaCZS5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:57:43 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <acme@ghostprotocols.net>
Subject: [PATCH] perf: make perf script actually spit out backtraces for events
Date: Wed, 26 Mar 2014 14:57:25 -0400
Message-ID: <1395860245-12418-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-26_05:2014-03-26,2014-03-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=8.78574990537118e-13 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997797291669616
 urlsuspect_oldscore=0.997797291669616 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997797291669616 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1403260102
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are trying to debug a problem internally and noticed that if we use perf
record -g -e <tracepoint> and then try to use perf script to get the events and
their backtraces that we weren't getting the backtraces, even though they were
collected and would show up with perf report.  For some reason the tracepoint
print stuff didn't have the right things set in order to print out backtraces.
I have no idea why this is as adding them in there makes the backtraces come out
properly, and if we don't use the -g option perf script still acts properly with
those options set.  Hopefully this is the correct fix, it has fixed the problem
for us.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
NOTE: I looked at MAINTAINERS to see if there was a perf list and it didn't look
like there was one, sorry if this is the wrong place to send patches to.

 tools/perf/builtin-script.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index baf1798..6d14c06 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -99,7 +99,9 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 				  PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
+				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE |
+				  PERF_OUTPUT_IP | PERF_OUTPUT_SYM |
+				  PERF_OUTPUT_DSO,
 	},
 
 	[PERF_TYPE_RAW] = {
-- 
1.8.3.1

