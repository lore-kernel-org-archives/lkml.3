Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab3KAWIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:08:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab3KAWIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 38/66] wanxl: fix info leak in ioctl
Date: Fri,  1 Nov 2013 15:07:14 -0700
Message-Id: <20131101220645.206591650@linuxfoundation.org>
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

[ Upstream commit 2b13d06c9584b4eb773f1e80bbaedab9a1c344e1 ]

The wanxl_ioctl() code fails to initialize the two padding bytes of
struct sync_serial_settings after the ->loopback member. Add an explicit
memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/wanxl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -355,6 +355,7 @@ static int wanxl_ioctl(struct net_device
 			ifr->ifr_settings.size = size; /* data size wanted */
 			return -ENOBUFS;
 		}
+		memset(&line, 0, sizeof(line));
 		line.clock_type = get_status(port)->clocking;
 		line.clock_rate = 0;
 		line.loopback = 0;


