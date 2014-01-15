Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaAOQmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:42:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40913 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbaAOQl6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:41:58 -0500
From: Gaurav Jain <gjain@fb.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Pekka Enberg <penberg@iki.fi>, Ingo Molnar <mingo@kernel.org>,
        "acme@redhat.com" <acme@redhat.com>
Subject: Perf map file ownership check
Thread-Topic: Perf map file ownership check
Thread-Index: Ac8SEK+ry7vZnGqLR8yU2of67CmjRA==
Date: Wed, 15 Jan 2014 16:41:49 +0000
Message-ID: <357ED2BF-5CA6-454B-B433-BC6F6542D105@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C00D0E0CEC28949A3FF42CE9F889D16@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-15_05:2014-01-15,2014-01-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.35894793646041e-08 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997600857122248
 urlsuspect_oldscore=0.997600857122248 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997600857122248 spamscore=0
 recipient_to_sender_domain_totalscore=2 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401150099
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

981c125 introduced a permission check on perf map files such that perf only loads the map file if it has ownership. Pekka mentioned that this prevents the perf tool from injecting arbitrary symbols from potentially malicious source.

In our workload, the code generating the map file is running as a non-root user. However, the perf tool is run as root. As a result, the ownership check fails and the map file is not loaded.

This raises 2 questions:
1. Is the ownership check necessary? What are the security implications of using symbols from an arbitrary source? I thought these are simply displayed by the perf tool.
2. Is there a way to avoid the check? Possibly with a -f flag.

Thanks,

Gaurav