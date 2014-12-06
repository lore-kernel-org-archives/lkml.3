Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaLFRzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:55:00 -0500
Received: from 1wt.eu ([62.212.114.60]:40710 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaLFRy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:56 -0500
Message-Id: <20141206174149.505885325@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:42:13 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Andy Whitcroft <apw@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 25/25] ttusb-dec: buffer overflow in ioctl
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit dc0ab1ddeb0c5f5eb3f37a72eadb394792b3c40d upstream

We need to add a limit check here so we don't overflow the buffer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
(backported from commit f2e323ec96077642d397bb1c355def536d489d16)
CVE-2014-8884
BugLink: http://bugs.launchpad.net/bugs/1395187
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
index 21260aa..852870b 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -154,6 +154,9 @@ static int ttusbdecfe_dvbs_diseqc_send_master_cmd(struct dvb_frontend* fe, struc
 		   0x00, 0x00, 0x00, 0x00,
 		   0x00, 0x00 };
 
+	if (cmd->msg_len > sizeof(b) - 4)
+		return -EINVAL;
+
 	memcpy(&b[4], cmd->msg, cmd->msg_len);
 
 	state->config->send_command(fe, 0x72,
-- 
1.7.12.2.21.g234cd45.dirty



