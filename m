Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaKGOPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:15:16 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54178 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752708AbaKGOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:15:05 -0500
Message-ID: <545CD3C6.9080408@arm.com>
Date: Fri, 07 Nov 2014 14:14:30 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/5] serial: pl011: Fix DMA issues on 64bit PL330 based systems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes a number of issues found when using
DMA driven UART transfers on the PL011 UART through a
DMA330 DMA controller on a 64bit system.

Andrew Jackson (5):
  serial: pl011: Allocate TX DMA buffer from DMA capable memory
  serial: pl011: Avoid assumptions about buffer size when refilling TX
    DMA
  serial: pl011: Set length of DMA transfer
  serial: pl011: Don't enable RX DMA if residue processing not
    supported
  serial: pl011: Add device tree support for RX DMA polling

 Documentation/devicetree/bindings/serial/pl011.txt |   19 +++++---
 drivers/tty/serial/amba-pl011.c                    |   46 +++++++++++++++++--
 2 files changed, 53 insertions(+), 12 deletions(-)


