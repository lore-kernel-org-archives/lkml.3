Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaIQQew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:34:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:49928 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbaIQQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:34:50 -0400
Message-ID: <5419B825.5000201@linutronix.de>
Date: Wed, 17 Sep 2014 18:34:45 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
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
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 01:42 PM, Sebastian Andrzej Siewior wrote:
>> We should add hooks like tx_dma and rx_dma to struct uart_8250_dma so
>> that the probe drivers can replace serial8250_tx_dma and
>> seria8250_rx_dma, like I think Alan already suggested.
> 
> Okay. Wasn't aware that Alan already suggested that.
> I also need a watchdog timer for TX since it seems that on omap3 the
> DMA engine suddenly forgets to continue with DMA…
> 
> If this is really what we want, I would need to refactor a few things…
> 
>> Let's keep serial8250_tx_dma/rx_dma as the default, and not add any
>> quirks to them. Only if there is a very common case should it be
>> handled in those. The case of RX req needing to be sent before data in
>> FIFO maybe one of those, but I'm no sure.
> 
> keep in mind that both (RX & TX bugs/hacks) need also a bit of handling
> in the 8250-core so it works together (like the tx_err member so we
> fall back to manual xmit)

Done. I've kept the RX workarounds in the 8250_dma and moved the TX
part into the omap driver.
I needed to add the 8250_core pieces of patch #10 [0]. Now If you say,
couldn't this done in an other way then I could move the RX workarounds
pieces to the omap driver as well as the interrupt routine. Any
preferences?

[0] [PATCH 10/16] tty: serial: 8250_dma: optimize the xmit path due to
    UART_BUG_DMA_TX

Sebastian

