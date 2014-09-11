Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaIKMdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:33:09 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51544 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754377AbaIKMdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:33:05 -0400
Message-ID: <5411967A.6090406@hurleysoftware.com>
Date: Thu, 11 Sep 2014 08:32:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de>
In-Reply-To: <54118AAB.2010205@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 07:42 AM, Sebastian Andrzej Siewior wrote:
> I also need a watchdog timer for TX since it seems that on omap3 the
> DMA engine suddenly forgets to continue with DMA…

One difference I noticed between the omap driver and the 8250 driver is
the way modem status interrupts are handled.

The omap driver only checks modem status for the UART_IIR_MSI interrupt type.
The 8250 driver checks modem status at every interrupt (other than NO_INT).

I think the UART_MSR_DCTS bit always reflects that the CTS input has changed
between reads of the MSR _even if auto CTS is on_. So perhaps the hardware
is being stopped by uart_handle_cts_change() when auto CTS is on?

Regards,
Peter Hurley

[The UPF_HARD_FLOW thing was pretty much just done for omap even though
8250 already had auto CTS/auto RTS. Serial core hardware flow control support
needs a redo as drivers have pretty much tacked stuff on randomly.]
