Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab3B0Acn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:32:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3BZX65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Kettenis <mark.kettenis@xs4all.nl>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 29/53] sunvdc: Fix off-by-one in generic_request().
Date: Tue, 26 Feb 2013 15:57:58 -0800
Message-Id: <20130226235622.876953094@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit f4d9605434c0fd4cc8639bf25cfc043418c52362 ]

The 'operations' bitmap corresponds one-for-one with the operation
codes, no adjustment is necessary.

Reported-by: Mark Kettenis <mark.kettenis@xs4all.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/sunvdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -461,7 +461,7 @@ static int generic_request(struct vdc_po
 	int op_len, err;
 	void *req_buf;
 
-	if (!(((u64)1 << ((u64)op - 1)) & port->operations))
+	if (!(((u64)1 << (u64)op) & port->operations))
 		return -EOPNOTSUPP;
 
 	switch (op) {


