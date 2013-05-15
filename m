Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab3EOJCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:02:42 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:43020
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab3EOJCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:02:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 0/4] Export the ecc step size to user applications
Date: Wed, 15 May 2013 16:46:42 +0800
Message-ID: <1368607606-4344-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to implement the NAND boot for some Freescale's chips, such as
imx23/imx28/imx50/imx6, we use a tool (called kobs-ng) to burn the uboot
and some metadata to nand chip. And the ROM code will use the metadata to
configrate the BCH, and to find the uboot.

The ECC information(ecc step size, ecc strength) which is used to configrate
the BCH is part of the metadata. The kobs-ng can gets the ecc strength from
the sys node /sys/*/mtdX/ecc_strength now. But it can't gets the ecc step size.

This patch set is used to export the ecc step size to user applications.
With this patch set, the kobs-ng can gets the ecc step size now.

v1 --> v2:
	[1] rename the ecc_size to ecc_step.
	[2] rebase on the latest l2-mtd.

Huang Shijie (4):
  mtd: add a new field to mtd_info{}
  mtd: add a new sys node to show the ecc step size
  mtd: set the ecc step size for master/slave mtd_info
  mtd: gpmi: update the ecc step size for mtd_info{}

 drivers/mtd/mtdcore.c                  |   11 +++++++++++
 drivers/mtd/mtdpart.c                  |    1 +
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |    1 +
 drivers/mtd/nand/nand_base.c           |    1 +
 include/linux/mtd/mtd.h                |    3 +++
 5 files changed, 17 insertions(+), 0 deletions(-)


