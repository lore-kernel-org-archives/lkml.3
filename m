Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaDXWAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:00:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbaDXVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:53:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Durrant <paul.durrant@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 11/27] xen-netback: remove pointless clause from if statement
Date: Thu, 24 Apr 2014 14:55:45 -0700
Message-Id: <20140424215552.290585848@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424215551.942390050@linuxfoundation.org>
References: <20140424215551.942390050@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Durrant <Paul.Durrant@citrix.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -338,8 +338,8 @@ static bool start_new_rx_buffer(int offs
 	 * into multiple copies tend to give large frags their
 	 * own buffers as before.
 	 */
-	if ((offset + size > MAX_BUFFER_OFFSET) &&
-	    (size <= MAX_BUFFER_OFFSET) && offset && !head)
+	BUG_ON(size > MAX_BUFFER_OFFSET);
+	if ((offset + size > MAX_BUFFER_OFFSET) && offset && !head)
 		return true;
 
 	return false;


