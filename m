Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936752Ab3DJN6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:58:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:55949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936145Ab3DJN6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:58:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="284281384"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 0/9] serial: 8250_dma to use the new dmaengine helpers
Date: Wed, 10 Apr 2013 16:58:23 +0300
Message-Id: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These will update 8250_dma to take advantage of the new dmaengine API helpers
that makes it possible to request channels without the filter parameters. The
helpers also support ACPI on top of DT, so the ACPI specific DMA information
parsing in 8250_dw can also be dropped.

These also include a few minor improvements for both 8250_dma and 8250_dw plus
runtime PM support for 8250_dw.


Heikki Krogerus (9):
  serial: 8250_dma: TX cleanup
  serial: 8250_dma: Fix RX handling
  serial: 8250_dma: Use dmaengine helpers to get the slave channels
  serial: 8250_dma: Provide default slave configuration parameters
  serial: 8250_dw: Enable runtime PM
  serial: 8250_dw: Support clk framework also with ACPI
  serial: 8250_dw: Let ACPI code extract the DMA client info
  serial: 8250_dw: Set port capabilities based on CPR register
  serial: 8250_dw: Use devm_request_and_ioremap()

 drivers/tty/serial/8250/8250_dma.c |   52 ++++++++----
 drivers/tty/serial/8250/8250_dw.c  |  158 ++++++++++++++++--------------------
 2 files changed, 104 insertions(+), 106 deletions(-)

-- 
1.7.10.4

