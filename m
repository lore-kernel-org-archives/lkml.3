Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab3HNDgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:36:54 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:12489 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305Ab3HNDgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:36:52 -0400
Message-ID: <520AFB3F.2090006@huawei.com>
Date: Wed, 14 Aug 2013 11:36:31 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <pantelis.antoniou@gmail.com>,
        <vbordug@ru.mvista.com>, Greg KH <gregkh@linuxfoundation.org>,
        <jg1.han@samsung.com>
Subject: [PATCH RESEND 0/8] use platform_{get,set}_drvdata()
References: <5208E20A.4010306@huawei.com>
In-Reply-To: <5208E20A.4010306@huawei.com>
X-Forwarded-Message-Id: <5208E20A.4010306@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We can use the wrapper functions platform_{get,set}_drvdata() instead of
dev_{get,set}_drvdata() with &pdev->dev, it is convenient for user.

Also, unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

changelog:
	this version add modify record about dev_set_drvdata().

Libo Chen (8):
  net: fsl_pq_mdio: use platform_{get,set}_drvdata()
  net: ucc_geth: use platform_{get,set}_drvdata()
  net: fec_mpc52xx_phy: use platform_{get,set}_drvdata()
  net: fs_enet: remove unnecessary dev_set_drvdata()
  net: sunbmac: use platform_{get,set}_drvdata()
  net: sunhme: use platform_{get,set}_drvdata()
  net: xilinx_emaclite: use platform_{get,set}_drvdata()
  net: davinci_mdio: use platform_{get,set}_drvdata()

 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    4 +---
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c  |    1 -
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |    3 +--
 drivers/net/ethernet/freescale/ucc_geth.c          |    4 +---
 drivers/net/ethernet/sun/sunbmac.c                 |    3 +--
 drivers/net/ethernet/sun/sunhme.c                  |    8 +++-----
 drivers/net/ethernet/ti/davinci_mdio.c             |    4 +---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    4 +---
 8 files changed, 9 insertions(+), 22 deletions(-)



