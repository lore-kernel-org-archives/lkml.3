Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab3CZSDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:03:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3CZRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:04 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mTWxCXrlA9gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=E6vUlD_fdxYA:10 a=yPCof4ZbAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=7DSvI1NPTFQA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173602.220885843@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 15/86] isdn/gigaset: fix zero size border case in debug dump
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0015-isdn-gigaset-fix-zero-size-border-case-in-debug-dump.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

[ Upstream commit d721a1752ba544df8d7d36959038b26bc92bdf80 ]

If subtracting 12 from l leaves zero we'd do a zero size allocation,
leading to an oops later when we try to set the NUL terminator.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/isdn/gigaset/capi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 68452b7..03a0a01 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -248,6 +248,8 @@ static inline void dump_rawmsg(enum debuglevel level, const char *tag,
 		CAPIMSG_APPID(data), CAPIMSG_MSGID(data), l,
 		CAPIMSG_CONTROL(data));
 	l -= 12;
+	if (l <= 0)
+		return;
 	dbgline = kmalloc(3 * l, GFP_ATOMIC);
 	if (!dbgline)
 		return;
-- 
1.7.10.4


