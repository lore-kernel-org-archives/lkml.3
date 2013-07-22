Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab3GVSwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:52:50 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:55828 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab3GVSws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:52:48 -0400
Message-ID: <51ED7F7C.2080205@cogentembedded.com>
Date: Mon, 22 Jul 2013 22:52:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/16] dmaengine: add transfered member to dma_async_tx_descriptor
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-16-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1374516607-2705-16-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 10:10 PM, Sebastian Andrzej Siewior wrote:

> In USB RX path it is possible that the we receive less bytes than
> requested. Take the following example:
> The driver for USB-to-UART submits an URB with 256 bytes in size and the
> dmaengine driver in turn programs a transfer of 256 bytes. The transfer
> is programmed and the dma engine waits for the data to arrive. Once data
> is sent on the UART the dma engine begins to move data. If there was
> only one data byte in the USB packet received then the DMA engine will
> only move one byte due to USB restrictions / rules. The real size of the
> transfer has to be notified to the user / caller so he set this to the
> caller.
> This patch adds the transfered member to the dma_async_tx_descriptor
> where the caller can obtain the final size.

> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>   include/linux/dmaengine.h | 3 +++
>   1 file changed, 3 insertions(+)

> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index cb286b1..c3a4635 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -403,6 +403,8 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
>    * @tx_submit: set the prepared descriptor(s) to be executed by the engine
>    * @callback: routine to call after this operation is complete
>    * @callback_param: general parameter to pass to the callback routine
> + * @transfered: number of bytes that were really transfered in case the channel
> + *	transfered less than requested.
>    * ---async_tx api specific fields---
>    * @next: at completion submit this descriptor
>    * @parent: pointer to the next level up in the dependency chain
> @@ -416,6 +418,7 @@ struct dma_async_tx_descriptor {
>   	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
>   	dma_async_tx_callback callback;
>   	void *callback_param;
> +	unsigned int transfered;

    Correct grammar is "transferred".

WBR, Sergei

