Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaLZHFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:05:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28875 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751140AbaLZHFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:05:12 -0500
From: Alex Gartrell <agartrell@fb.com>
To: <davem@davemloft.net>, <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Alex Gartrell <agartrell@fb.com>
Subject: [PATCH net-next] tun: Fixed unsigned/signed comparison
Date: Thu, 25 Dec 2014 23:05:03 -0800
Message-ID: <1419577503-12862-1-git-send-email-agartrell@fb.com>
X-Mailer: git-send-email 1.8.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_06:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.87658777406341e-11 kscore.compositescore=0
 circleOfTrustscore=502.112 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412260076
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Validated that this was actually using the unsigned comparison with gdb.

Signed-off-by: Alex Gartrell <agartrell@fb.com>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a5cbf67..6c63e21 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1499,7 +1499,7 @@ static int tun_recvmsg(struct kiocb *iocb, struct socket *sock,
 		goto out;
 	}
 	ret = tun_do_read(tun, tfile, &m->msg_iter, flags & MSG_DONTWAIT);
-	if (ret > total_len) {
+	if (ret > (ssize_t)total_len) {
 		m->msg_flags |= MSG_TRUNC;
 		ret = flags & MSG_TRUNC ? ret : total_len;
 	}
-- 
Alex Gartrell <agartrell@fb.com>

