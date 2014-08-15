Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaHORnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:43:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:57633 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHORm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:42:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v7] 8250-core based serial driver for OMAP + DMA
Date: Fri, 15 Aug 2014 19:42:28 +0200
Message-Id: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my complete queue fo the omap serial driver based on the 8250 core
code. I played with it on beagle bone, am335x-evm and dra7xx including DMA.
The uncertain remain the runtime-pm pieces.
I hacked a small serial testing application which sent 10x 4KiB of data in
raw mode. The number of interrupts in comparison:

    serial-omap | 8250 omap | 8250 omap + dma |
   --------------------------------------------
TX |       2558 |       641 |         0 +  30 |
RX |      40960 |       854 |         1 + 853 |

So the 8250 version uses less interrupts for the same amount of data.
The consequence is that in TX mode there should be "short" periods where
no data is sent (before the CPU gets to re-fill the FIFO). On RX we have
a smaller time frame where we have to start to purge the FIFO before it
overflows.

Sebastian

