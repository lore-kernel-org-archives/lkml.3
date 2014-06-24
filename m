Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaFXPyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:54:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaFXPyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 22/68] sh_eth: fix SH7619/771x support
Date: Tue, 24 Jun 2014 11:50:41 -0400
Message-Id: <20140624154724.915129965@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit d8b0426af5b67973585712c9af36b86f6ea97815 ]

Commit 4a55530f38e4 (net: sh_eth: modify the definitions of register) managed
to leave out the E-DMAC register entries in sh_eth_offset_fast_sh3_sh2[], thus
totally breaking SH7619/771x support.  Add the missing entries using  the data
from before that commit.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/sh_eth.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -301,6 +301,27 @@ static const u16 sh_eth_offset_fast_sh4[
 };
 
 static const u16 sh_eth_offset_fast_sh3_sh2[SH_ETH_MAX_REGISTER_OFFSET] = {
+	[EDMR]		= 0x0000,
+	[EDTRR]		= 0x0004,
+	[EDRRR]		= 0x0008,
+	[TDLAR]		= 0x000c,
+	[RDLAR]		= 0x0010,
+	[EESR]		= 0x0014,
+	[EESIPR]	= 0x0018,
+	[TRSCER]	= 0x001c,
+	[RMFCR]		= 0x0020,
+	[TFTR]		= 0x0024,
+	[FDR]		= 0x0028,
+	[RMCR]		= 0x002c,
+	[EDOCR]		= 0x0030,
+	[FCFTR]		= 0x0034,
+	[RPADIR]	= 0x0038,
+	[TRIMD]		= 0x003c,
+	[RBWAR]		= 0x0040,
+	[RDFAR]		= 0x0044,
+	[TBRAR]		= 0x004c,
+	[TDFAR]		= 0x0050,
+
 	[ECMR]		= 0x0160,
 	[ECSR]		= 0x0164,
 	[ECSIPR]	= 0x0168,


