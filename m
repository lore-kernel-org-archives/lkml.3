Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbbAYS4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:56:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbbAYSJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>, Imre Palik <imrep@amazon.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 022/183] xen-netback: fixing the propagation of the transmit shaper timeout
Date: Sun, 25 Jan 2015 10:05:44 -0800
Message-Id: <20150125180811.132909254@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Palik, Imre" <imrep@amazon.de>

[ Upstream commit 07ff890daeda31cf23173865edf50bcb03e100c3 ]

Since e9ce7cb6b107 ("xen-netback: Factor queue-specific data into queue struct"),
the transimt shaper timeout is always set to 0.  The value the user sets via
xenbus is never propagated to the transmit shaper.

This patch fixes the issue.

Cc: Anthony Liguori <aliguori@amazon.com>
Signed-off-by: Imre Palik <imrep@amazon.de>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/xenbus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -736,6 +736,7 @@ static void connect(struct backend_info
 		}
 
 		queue->remaining_credit = credit_bytes;
+		queue->credit_usec = credit_usec;
 
 		err = connect_rings(be, queue);
 		if (err) {


