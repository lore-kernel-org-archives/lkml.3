Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaIANPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:15:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26693 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIANPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:15:41 -0400
X-AuditID: cbfee61b-f79f86d00000144c-cd-5404717b5713
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sh_eth: fix driver dependencies
Date: Mon, 01 Sep 2014 15:15:37 +0200
Message-id: <3693021.H9Y3NelqF1@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd3qQpYQg76NShZzzrewWDRv/cpo
	cbbpDbvF5V1z2Czm/JnCbPFg9Vs2i2MLxBzYPbasvMnksXPWXXaPvi2rGD3m/PzG4vF5k1wA
	axSXTUpqTmZZapG+XQJXxsl1txgLPrNVbL+8jrmB8RtrFyMnh4SAicTD7VuYIGwxiQv31rOB
	2EIC0xklrl7y72LkArJbmCTWrDnLDJJgE7CSmNi+ihHEFhHQllh3oIcVpIhZ4CSjxNpJi8C6
	hQVMJW5vWMkCYrMIqEosOPYMLM4roCkx9fQEsM2iAp4SO7avhIoLSvyYfA+snllAXmLf/qms
	ELaWxPqdx5kmMPLNQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB+0z
	6R2MqxosDjEKcDAq8fA+mMUcIsSaWFZcmXuIUYKDWUmENzWDJUSINyWxsiq1KD++qDQntfgQ
	ozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDY+r2l++nNBc9lU1p/6IsslfRWWWdU6Dm
	78PHfcrq3VNOTZPPv6MuadXOISdRtIpN1rvA963Hvtut+RPOLJRVWvDGJkLNxq/tFoPs9rK3
	p6e7POK7enCSzNdFZzKLiztjlqk8qJ3z9+W/Y3WTE0MywyRObpof4nzh13Ob5SnvXJesMsws
	e3CkV4mlOCPRUIu5qDgRAEkgsBtWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renesas SuperH Ethernet support should be available only on
Renesas ARM SoCs and SuperH architecture.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
---
 drivers/net/ethernet/renesas/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/net/ethernet/renesas/Kconfig
===================================================================
--- a/drivers/net/ethernet/renesas/Kconfig	2014-07-30 14:31:20.479522692 +0200
+++ b/drivers/net/ethernet/renesas/Kconfig	2014-09-01 14:45:36.160544016 +0200
@@ -5,6 +5,7 @@
 config SH_ETH
 	tristate "Renesas SuperH Ethernet support"
 	depends on HAS_DMA
+	depends on ARCH_SHMOBILE || ARCH_SH || COMPILE_TEST
 	select CRC32
 	select MII
 	select MDIO_BITBANG

