Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3FDXOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:14:23 -0400
Received: from 1wt.eu ([62.212.114.60]:35433 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab3FDWmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:18 -0400
Message-Id: <20130604172133.000994672@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chen Gang <gang.chen@asianux.com>, Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 065/184] drivers/char/ipmi: memcpy, need additional 2 bytes
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 to avoid memory overflow

From: Chen Gang <gang.chen@asianux.com>

commit a5f2b3d6a738e7d4180012fe7b541172f8c8dcea upstream.

When calling memcpy, read_data and write_data need additional 2 bytes.

  write_data:
    for checking:  "if (size > IPMI_MAX_MSG_LENGTH)"
    for operating: "memcpy(bt->write_data + 3, data + 1, size - 1)"

  read_data:
    for checking:  "if (msg_len < 3 || msg_len > IPMI_MAX_MSG_LENGTH)"
    for operating: "memcpy(data + 2, bt->read_data + 4, msg_len - 2)"

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/ipmi/ipmi_bt_sm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index 7b98c06..a65a574 100644
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
1.7.12.2.21.g234cd45.dirty



