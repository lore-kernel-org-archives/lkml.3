Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaANBDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:03:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaANA1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 09/62] macvtap: update file current position
Date: Mon, 13 Jan 2014 16:26:34 -0800
Message-Id: <20140114002710.730686210@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

[ Upstream commit e6ebc7f16ca1434a334647aa56399c546be4e64b ]

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvtap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -903,6 +903,8 @@ static ssize_t macvtap_aio_read(struct k
 
 	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
+	if (ret > 0)
+		iocb->ki_pos = ret;
 out:
 	return ret;
 }


