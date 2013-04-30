Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab3D3Hwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:52:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57859 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3D3Hwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:52:47 -0400
X-AuditID: cbfee68d-b7f016d000007930-dc-517f7839e48a
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Davidlohr Bueso'" <davidlohr.bueso@hp.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
In-reply-to: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
Subject: [PATCH 3.8-stable] lib/int_sqrt.c: optimize square root algorithm
Date: Tue, 30 Apr 2013 16:52:24 +0900
Message-id: <006d01ce4577$a762ae10$f6280a30$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAAEqHoAC1cPGABGTGq0A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ13LivpAg+mXVSzmrF/DZtG37B+b
	xZJmbovLu+awWSzY+IjRgdVj17adTB4nZvxm8ejbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	nquXGAtOKFRM6HzL2MC4QrSLkZNDQsBEYuvnGYwQtpjEhXvr2UBsIYFljBLPVrDD1Lw5fgjI
	5gKKT2eUuPdwDwuE85dR4tzlu6wgVWwCuhLH1m8Bs0UEvCVOTfnFDGIzC5RKNP3dzwox1U5i
	zb95QBs4ODgF7CWmfC4DCQsLeEk8b/oFtphFQFWib/M0sIN4gcrfzr7BBmELSvyYfI8FYqSW
	xPqdx5kgbHmJzWveMoOMlBBQl3j0VxfiAj+JmQ0roS4Qkdj34h0jyMkSApfYJSbv+8QKsUtA
	4tvkQywQvbISmw4wQ/wrKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kaFe
	cWJucWleul5yfu4mRkhs9u5gvH3A+hBjMtD6icxSosn5wNjOK4k3NDYzsjA1MTU2Mrc0I01Y
	SZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjKUtB7087C54jE8SVpl6vEnzr9kam
	Nfye3/VjWytuTLS/JLIp78qm++sOOwhcNncKmb5m+oWLEWVPNB+7LvjU9/r/+8unWSu+zHgh
	LPPdrfj+tL27NPqW37nI+o2T60Dx74xved1xnYx98/8kiz+/VzNJ4nw89zwBvuAJ4YqXAx9J
	f2q50WVtr8RSnJFoqMVcVJwIACfpuXrjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQV3LivpAg5PdChZz1q9hs+hb9o/N
	Ykkzt8XlXXPYLBZsfMTowOqxa9tOJo8TM36zePRtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QXiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jRs/VS4wFJxQqJnS+ZWxgXCHaxcjJISFgIvHm+CF2CFtM
	4sK99WxdjFwcQgLTGSXuPdzDAuH8ZZQ4d/kuK0gVm4CuxLH1W8BsEQFviVNTfjGD2MwCpRJN
	f/eDxYUE7CTW/JsHNImDg1PAXmLK5zKQsLCAl8Tzpl9sIDaLgKpE3+ZpjCA2L1D529k32CBs
	QYkfk++xQIzUkli/8zgThC0vsXnNW2aQkRIC6hKP/upCXOAnMbNhJdQFIhL7XrxjnMAoNAvJ
	pFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJj/5nUDsaVDRaHGAU4
	GJV4eHcsqQsUYk0sK67MPcQowcGsJMKrX1ofKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5
	wLSUVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MubYLqydd
	yBF5xJDTdOQc25Wu/5nL/9XwTPTy/FlTejdoecsxk5VRK/70G59jcsy+yL9e//wZbodXxvHN
	SVd57nzeN+kcz9bW5yFXs4MyJ52ccu+Xw+l/+2JcJ/18nN7u+nqWYLNX3/pwz56Y49rxSktc
	nWder+nLY+zINv6gGfFva2794VJdJZbijERDLeai4kQA26GNVkEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Davidlohr Bueso <davidlohr.bueso@hp.com>"

commit 30493cc9dddb68066dcc4878015660fdaa8e0965 upstream

Optimize the current version of the shift-and-subtract (hardware)
algorithm, described by John von Newmann[1] and Guy L Steele.

Iterating 1,000,000 times, perf shows for the current version:

 Performance counter stats for './sqrt-curr' (10 runs):

         27.170996 task-clock                #    0.979 CPUs utilized
( +-  3.19% )
                 3 context-switches          #    0.103 K/sec
( +-  4.76% )
                 0 cpu-migrations            #    0.004 K/sec
( +-100.00% )
               104 page-faults               #    0.004 M/sec
( +-  0.16% )
        64,921,199 cycles                    #    2.389 GHz
( +-  0.03% )
        28,967,789 stalled-cycles-frontend   #   44.62% frontend cycles idle
( +-  0.18% )
   <not supported> stalled-cycles-backend
       104,502,623 instructions              #    1.61  insns per cycle
                                             #    0.28  stalled cycles per
insn  ( +-  0.00% )
        34,088,368 branches                  # 1254.587 M/sec
( +-  0.00% )
             4,901 branch-misses             #    0.01% of all branches
( +-  1.32% )

       0.027763015 seconds time elapsed
( +-  3.22% )

And for the new version:

Performance counter stats for './sqrt-new' (10 runs):

          0.496869 task-clock                #    0.519 CPUs utilized
( +-  2.38% )
                 0 context-switches          #    0.000 K/sec
                 0 cpu-migrations            #    0.403 K/sec
( +-100.00% )
               104 page-faults               #    0.209 M/sec
( +-  0.15% )
           590,760 cycles                    #    1.189 GHz
( +-  2.35% )
           395,053 stalled-cycles-frontend   #   66.87% frontend cycles idle
( +-  3.67% )
   <not supported> stalled-cycles-backend
           398,963 instructions              #    0.68  insns per cycle
                                             #    0.99  stalled cycles per
insn  ( +-  0.39% )
            70,228 branches                  #  141.341 M/sec
( +-  0.36% )
             3,364 branch-misses             #    4.79% of all branches
( +-  5.45% )

       0.000957440 seconds time elapsed
( +-  2.42% )

Furthermore, this saves space in instruction text:

   text    data     bss     dec     hex filename
    111       0       0     111      6f lib/int_sqrt-baseline.o
     89       0       0      89      59 lib/int_sqrt.o

[1] http://en.wikipedia.org/wiki/First_Draft_of_a_Report_on_the_EDVAC

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reviewed-by: Jonathan Gonzalez <jgonzlez@linets.cl>
Tested-by: Jonathan Gonzalez <jgonzlez@linets.cl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 lib/int_sqrt.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/lib/int_sqrt.c b/lib/int_sqrt.c
index fc2eeb7..1ef4cc3 100644
--- a/lib/int_sqrt.c
+++ b/lib/int_sqrt.c
@@ -1,3 +1,9 @@
+/*
+ * Copyright (C) 2013 Davidlohr Bueso <davidlohr.bueso@hp.com>
+ *
+ *  Based on the shift-and-subtract algorithm for computing integer
+ *  square root from Guy L. Steele.
+ */
 
 #include <linux/kernel.h>
 #include <linux/export.h>
@@ -10,23 +16,23 @@
  */
 unsigned long int_sqrt(unsigned long x)
 {
-	unsigned long op, res, one;
+	unsigned long b, m, y = 0;
 
-	op = x;
-	res = 0;
+	if (x <= 1)
+		return x;
 
-	one = 1UL << (BITS_PER_LONG - 2);
-	while (one > op)
-		one >>= 2;
+	m = 1UL << (BITS_PER_LONG - 2);
+	while (m != 0) {
+		b = y + m;
+		y >>= 1;
 
-	while (one != 0) {
-		if (op >= res + one) {
-			op = op - (res + one);
-			res = res +  2 * one;
+		if (x >= b) {
+			x -= b;
+			y += m;
 		}
-		res /= 2;
-		one /= 4;
+		m >>= 2;
 	}
-	return res;
+
+	return y;
 }
 EXPORT_SYMBOL(int_sqrt);
-- 
1.7.9.5

