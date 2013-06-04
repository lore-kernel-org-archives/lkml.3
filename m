Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3FDWnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:33 -0400
Received: from 1wt.eu ([62.212.114.60]:35722 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757Ab3FDWnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:24 -0400
Message-Id: <20130604172134.289212229@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 096/184] telephony: ijx: buffer overflow in ixj_write_cid()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[Not needed in 3.8 or newer as this driver is removed there. - gregkh]

We get this from user space and nothing has been done to ensure that
these strings are NUL terminated.

Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/telephony/ixj.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 40de151..56eb6cc 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -3190,12 +3190,12 @@ static void ixj_write_cid(IXJ *j)
 
 	ixj_fsk_alloc(j);
 
-	strcpy(sdmf1, j->cid_send.month);
-	strcat(sdmf1, j->cid_send.day);
-	strcat(sdmf1, j->cid_send.hour);
-	strcat(sdmf1, j->cid_send.min);
-	strcpy(sdmf2, j->cid_send.number);
-	strcpy(sdmf3, j->cid_send.name);
+	strlcpy(sdmf1, j->cid_send.month, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.day, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.hour, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.min, sizeof(sdmf1));
+	strlcpy(sdmf2, j->cid_send.number, sizeof(sdmf2));
+	strlcpy(sdmf3, j->cid_send.name, sizeof(sdmf3));
 
 	len1 = strlen(sdmf1);
 	len2 = strlen(sdmf2);
@@ -3340,12 +3340,12 @@ static void ixj_write_cidcw(IXJ *j)
 		ixj_pre_cid(j);
 	}
 	j->flags.cidcw_ack = 0;
-	strcpy(sdmf1, j->cid_send.month);
-	strcat(sdmf1, j->cid_send.day);
-	strcat(sdmf1, j->cid_send.hour);
-	strcat(sdmf1, j->cid_send.min);
-	strcpy(sdmf2, j->cid_send.number);
-	strcpy(sdmf3, j->cid_send.name);
+	strlcpy(sdmf1, j->cid_send.month, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.day, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.hour, sizeof(sdmf1));
+	strlcat(sdmf1, j->cid_send.min, sizeof(sdmf1));
+	strlcpy(sdmf2, j->cid_send.number, sizeof(sdmf2));
+	strlcpy(sdmf3, j->cid_send.name, sizeof(sdmf3));
 
 	len1 = strlen(sdmf1);
 	len2 = strlen(sdmf2);
-- 
1.7.12.2.21.g234cd45.dirty



