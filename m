Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaHRKyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:54:21 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:46228 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaHRKyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:54:20 -0400
Date: Mon, 18 Aug 2014 11:52:49 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 07/15] tty: serial: 8250_dma: enqueue RX dma again on
 completion.
Message-ID: <20140818115249.537b3e42@alan.etchedpixels.co.uk>
In-Reply-To: <1408124563-31541-8-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
	<1408124563-31541-8-git-send-email-bigeasy@linutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  		if (!up->dma || dma_err)
>  			status = serial8250_rx_chars(up, status);
> +
> +		if (dma_err && port->type == PORT_OMAP_16750)
> +			serial8250_rx_dma(up, 0);

Can we stick to a 'has dma' flag and port->rx_dma() type usages so that
we don't have to rewrite it again to add them the next slightly odd DMA
user we add 8)

