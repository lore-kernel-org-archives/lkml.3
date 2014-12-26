Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaLZGuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 01:50:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54958 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751315AbaLZGuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 01:50:44 -0500
From: Alex Gartrell <agartrell@fb.com>
To: <davem@davemloft.net>, <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Alex Gartrell <agartrell@fb.com>
Subject: [PATCH net-next 0/2] tun: support socket system calls
Date: Thu, 25 Dec 2014 22:50:22 -0800
Message-ID: <1419576624-8999-1-git-send-email-agartrell@fb.com>
X-Mailer: git-send-email 1.8.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_06:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=502.112
 compositescore=0.986137415400633 urlsuspect_oldscore=0.986137415400633
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412260074
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an underlying socket object in struct tun that isn't accessible,
so if you try to do a recvmmsg on a tun file descriptor you'll get an
error. This small patchset allows external file objects to claim socket
status and enables it for tun_files.

Alex Gartrell (2):
  socket: Allow external sockets to use socket syscalls
  tun: enable socket system calls

 drivers/net/tun.c  | 34 ++++++++++++++++++++++------------
 include/linux/fs.h |  2 +-
 net/socket.c       |  3 ++-
 3 files changed, 25 insertions(+), 14 deletions(-)

-- 
Alex Gartrell <agartrell@fb.com>

