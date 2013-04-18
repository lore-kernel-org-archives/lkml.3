Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3DRISZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:18:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33499 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3DRISX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:18:23 -0400
Date: Thu, 18 Apr 2013 09:18:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2] serial: pl011: Add Device Tree support to request
	DMA channels
Message-ID: <20130418081811.GF14496@n2100.arm.linux.org.uk>
References: <1366272857-14038-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366272857-14038-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 09:14:16AM +0100, Lee Jones wrote:
> @@ -269,7 +270,10 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
>  	dma_cap_zero(mask);
>  	dma_cap_set(DMA_SLAVE, mask);
>  
> -	chan = dma_request_channel(mask, plat->dma_filter, plat->dma_tx_param);
> +	chan = dma_request_slave_channel_compat(mask,
> +				(plat) ? plat->dma_filter : NULL,
> +				(plat) ? plat->dma_tx_param : NULL,
> +				uap->port.dev, "tx");
>  	if (!chan) {
>  		dev_err(uap->port.dev, "no TX DMA channel!\n");
>  		return;

This suffers the same problem with your MMCI patch.  If you're using DT and
don't provide the DMA information, you get errors printed.  That's not on
for an optional driver feature, especially when that feature causes
functional difficulties on various platforms and so is _purposely_ omitted.
