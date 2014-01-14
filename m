Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaANA0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:26:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaANA0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 05/27] tun: update file current position
Date: Mon, 13 Jan 2014 16:26:19 -0800
Message-Id: <20140114002623.517394255@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002623.356220317@linuxfoundation.org>
References: <20140114002623.356220317@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

[ Upstream commit d0b7da8afa079ffe018ab3e92879b7138977fc8f ]

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -903,6 +903,8 @@ static ssize_t tun_chr_aio_read(struct k
 
 	ret = tun_do_read(tun, iocb, iv, len, file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len);
+	if (ret > 0)
+		iocb->ki_pos = ret;
 out:
 	tun_put(tun);
 	return ret;


