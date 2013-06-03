Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab3FCWaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:30:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803Ab3FCWaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:24 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=04-uFl7eWVYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5B99-4Pck_YA:10 a=40MIqcmNAAAA:8 a=fk1lIlRQAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=bohBJUHXQGjO17J8LeEA:9 a=-tENaG0q7zQA:10 a=gH_wm7_JyAQA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=N_-7imHBSO03CQz0:21 a=sG5N5H65mQL4OGRO:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221201.149811571@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chen Gang <gang.chen@asianux.com>, Corey Minyard <cminyard@mvista.com>
Subject: [52/65] drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory
 overflow
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0052-drivers-char-ipmi-memcpy-need-additional-2-bytes-to-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

[ Upstream commit a5f2b3d6a738e7d4180012fe7b541172f8c8dcea ]

When calling memcpy, read_data and write_data need additional 2 bytes.

  write_data:
    for checking:  "if (size > IPMI_MAX_MSG_LENGTH)"
    for operating: "memcpy(bt->write_data + 3, data + 1, size - 1)"

  read_data:
    for checking:  "if (msg_len < 3 || msg_len > IPMI_MAX_MSG_LENGTH)"
    for operating: "memcpy(data + 2, bt->read_data + 4, msg_len - 2)"

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/ipmi/ipmi_bt_sm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index cdd4c09f..a22a7a5 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -95,9 +95,9 @@ struct si_sm_data {
 	enum bt_states	state;
 	unsigned char	seq;		/* BT sequence number */
 	struct si_sm_io	*io;
-	unsigned char	write_data[IPMI_MAX_MSG_LENGTH];
+	unsigned char	write_data[IPMI_MAX_MSG_LENGTH + 2]; /* +2 for memcpy */
 	int		write_count;
-	unsigned char	read_data[IPMI_MAX_MSG_LENGTH];
+	unsigned char	read_data[IPMI_MAX_MSG_LENGTH + 2]; /* +2 for memcpy */
 	int		read_count;
 	int		truncated;
 	long		timeout;	/* microseconds countdown */
-- 
1.7.10.4


