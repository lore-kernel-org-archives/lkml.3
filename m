Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaDRJ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:27:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46036 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbaDRJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Durrant <Paul.Durrant@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 62/72] xen-netback: remove pointless clause from if statement
Date: Fri, 18 Apr 2014 11:22:35 +0200
Message-Id: <63273418e7e48018bfb432f13caca9eeaee00679.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Durrant <Paul.Durrant@citrix.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 0576eddf24df716d8570ef8ca11452a9f98eaab2 ]

This patch removes a test in start_new_rx_buffer() that checks whether
a copy operation is less than MAX_BUFFER_OFFSET in length, since
MAX_BUFFER_OFFSET is defined to be PAGE_SIZE and the only caller of
start_new_rx_buffer() already limits copy operations to PAGE_SIZE or less.

Signed-off-by: Paul Durrant <paul.durrant@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Wei Liu <wei.liu2@citrix.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Reported-By: Sander Eikelenboom <linux@eikelenboom.it>
Tested-By: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/xen-netback/netback.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 625585034ef4..74b09260457a 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -206,8 +206,8 @@ static bool start_new_rx_buffer(int offset, unsigned long size, int head)
 	 * into multiple copies tend to give large frags their
 	 * own buffers as before.
 	 */
-	if ((offset + size > MAX_BUFFER_OFFSET) &&
-	    (size <= MAX_BUFFER_OFFSET) && offset && !head)
+	BUG_ON(size > MAX_BUFFER_OFFSET);
+	if ((offset + size > MAX_BUFFER_OFFSET) && offset && !head)
 		return true;
 
 	return false;
-- 
1.9.2

