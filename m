Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbbA0OTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:19:41 -0500
Received: from bes.se.axis.com ([195.60.68.10]:54343 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbbA0OTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:19:39 -0500
Date: Tue, 27 Jan 2015 15:19:37 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH] cris: Remove unnecessary KERN_INFO from sync_serial.c
Message-ID: <20150127141937.GA26817@axis.com>
References: <1421322728-18968-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421322728-18968-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 12:52:08PM +0100, Masanari Iida wrote:
> This patch remove unnecessary KERN_INFO in sync_serial.c

Thanks, added for 3.20.

/Jesper

> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  arch/cris/arch-v32/drivers/sync_serial.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
> index 08a313f..91e8773 100644
> --- a/arch/cris/arch-v32/drivers/sync_serial.c
> +++ b/arch/cris/arch-v32/drivers/sync_serial.c
> @@ -1286,7 +1286,7 @@ static void start_dma_out(struct sync_port *port, const char *data, int count)
>  
>  		tr_cfg.tr_en = regk_sser_yes;
>  		REG_WR(sser, port->regi_sser, rw_tr_cfg, tr_cfg);
> -		DEBUGTRDMA(pr_info(KERN_INFO "dma s\n"););
> +		DEBUGTRDMA(pr_info("dma s\n"););
>  	} else {
>  		DMA_CONTINUE_DATA(port->regi_dmaout);
>  		DEBUGTRDMA(pr_info("dma c\n"););
> @@ -1443,7 +1443,7 @@ static inline void handle_rx_packet(struct sync_port *port)
>  	reg_dma_rw_ack_intr ack_intr = { .data = regk_dma_yes };
>  	unsigned long flags;
>  
> -	DEBUGRXINT(pr_info(KERN_INFO "!"));
> +	DEBUGRXINT(pr_info("!"));
>  	spin_lock_irqsave(&port->lock, flags);
>  
>  	/* If we overrun the user experience is crap regardless if we
> -- 
> 2.3.0.rc0

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
