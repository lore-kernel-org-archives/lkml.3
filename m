Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaFGRsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 13:48:33 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:49990 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaFGRsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 13:48:32 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2014 13:48:31 EDT
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wan: wanxl.c:  Cleaning up declaration of a while loop
References: <1402139018-17208-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sat, 07 Jun 2014 19:38:42 +0200
In-Reply-To: <1402139018-17208-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 7 Jun 2014 13:03:38 +0200")
Message-ID: <m3egz0mxgd.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Unusual declaration of a while loop.
> However, believe you also want to make sure that the pointer is not NULL

Not really. The code is meant to do exactly what it currently does -
set variable desc and then check desc->stat.
All rx_descs are at this point already initialized and not NULL
(if desc was indeed NULL we better BUG*() or Oops on desc->stat access
instead of failing silently).

> --- a/drivers/net/wan/wanxl.c
> +++ b/drivers/net/wan/wanxl.c
> @@ -196,7 +196,7 @@ static inline void wanxl_tx_intr(port_t *port)
>  static inline void wanxl_rx_intr(card_t *card)
>  {
>  	desc_t *desc;
> -	while (desc = &card->status->rx_descs[card->rx_in],
> +	while (desc = &card->status->rx_descs[card->rx_in] &&
>  	       desc->stat != PACKET_EMPTY) {
>  		if ((desc->stat & PACKET_PORT_MASK) > card->n_ports)
>  			pr_crit("%s: received packet for nonexistent port\n",

-- 
Krzysztof Halasa
