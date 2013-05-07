Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579Ab3EGEmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:42:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461Ab3EGEZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:41 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jZEH_UT-bzUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-TGOLCRGv-kA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035900.013171298@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [114/126] bonding: IFF_BONDING is not stripped on enslave failure
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0114-bonding-IFF_BONDING-is-not-stripped-on-enslave-failu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

[ Upstream commit b6a5a7b9a528a8b4c8bec940b607c5dd9102b8cc ]

While enslaving a new device and after IFF_BONDING flag is set, in case
of failure it is not stripped from the device's priv_flags while
cleaning up, which could lead to other problems.
Cleaning at err_close because the flag is set after dev_open().

v2: no change

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/bonding/bond_main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index bbd3ac1..1a93bab 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1893,6 +1893,7 @@ err_detach:
 	write_unlock_bh(&bond->lock);
 
 err_close:
+	slave_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(slave_dev);
 
 err_unset_master:
-- 
1.7.10.4


