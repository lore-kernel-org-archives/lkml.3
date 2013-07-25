Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab3GYO5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:57:00 -0400
Received: from smtp-out-037.synserver.de ([212.40.185.37]:1113 "EHLO
	smtp-out-036.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756103Ab3GYO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:56:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5035
Message-ID: <51F13CEB.7030408@metafoo.de>
Date: Thu, 25 Jul 2013 16:57:47 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 15/16] dmaengine: add transfered member to dma_async_tx_descriptor
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-16-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1374516607-2705-16-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 08:10 PM, Sebastian Andrzej Siewior wrote:
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

I'm not sure that this will work. Once you've submitted the descriptor it is
owned by the dmaengine driver and you are not allowed to dereference it
anymore since the dmaengine driver might free the memory at any time. You
should only reference the descriptor by the cookie returned by submit().

- Lars
