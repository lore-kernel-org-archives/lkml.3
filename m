Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238Ab3DBTfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:35:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59308 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762189Ab3DBTfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:35:10 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 02 Apr 2013 14:35:05 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        David Daney <david.daney@cavium.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 0/5] Provide empty functions if OF_NET is not configured
Date: Tue,  2 Apr 2013 12:35:06 -0700
Message-Id: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide empty functions for of_get_phy_mode() and of_get_mac_address()
if OF_NET is not configured. Modify affected drivers to rely on the
now available functions.

----------------------------------------------------------------
Guenter Roeck (5):
      of_net.h: Provide dummy functions if OF_NET is not configured
      net/cadence/at91_ether: Simplify OF dependencies
      net/cadence/macb: Simplify OF dependencies
      net/freescale/fec: Simplify OF dependencies
      net/nxp/lpc_eth: Drop ifdef CONFIG_OF_NET

 drivers/net/ethernet/cadence/at91_ether.c |   44 ++++-------------------------
 drivers/net/ethernet/cadence/macb.c       |   43 ++++------------------------
 drivers/net/ethernet/freescale/fec.c      |   19 +------------
 drivers/net/ethernet/nxp/lpc_eth.c        |    2 --
 include/linux/of_net.h                    |   10 +++++++
 5 files changed, 23 insertions(+), 95 deletions(-)
