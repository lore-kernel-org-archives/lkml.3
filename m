Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3KAWIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:08:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3KAWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 28/66] farsync: fix info leak in ioctl
Date: Fri,  1 Nov 2013 15:07:04 -0700
Message-Id: <20131101220642.550309993@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salva Peiró <speiro@ai2.upv.es>

[ Upstream commit 96b340406724d87e4621284ebac5e059d67b2194 ]

The fst_get_iface() code fails to initialize the two padding bytes of
struct sync_serial_settings after the ->loopback member. Add an explicit
memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/farsync.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1972,6 +1972,7 @@ fst_get_iface(struct fst_card_info *card
 	}
 
 	i = port->index;
+	memset(&sync, 0, sizeof(sync));
 	sync.clock_rate = FST_RDL(card, portConfig[i].lineSpeed);
 	/* Lucky card and linux use same encoding here */
 	sync.clock_type = FST_RDB(card, portConfig[i].internalClock) ==


