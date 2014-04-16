Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbaDPKdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:33:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51769 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbaDPKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Durrant <paul.durrant@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 32/46] xen-netback: remove pointless clause from if statement
Date: Wed, 16 Apr 2014 11:31:48 +0100
Message-Id: <1397644322-13905-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Durrant <Paul.Durrant@citrix.com>

commit 0576eddf24df716d8570ef8ca11452a9f98eaab2 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netback/netback.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index ac55997..3335983 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -354,8 +354,8 @@ static bool start_new_rx_buffer(int offset, unsigned long size, int head)
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
1.9.1

