Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab3GKGqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:46:12 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:48833 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3GKGqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:46:10 -0400
Date: Thu, 11 Jul 2013 09:46:05 +0300
From: Aldo Iljazi <neonsync1@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers: tty: n_gsm.c: fixed 7 errors & 6 warnings that
 checkpatch complained
Message-ID: <20130711064604.GB10611@gmail.com>
References: <1373311680-24414-1-git-send-email-neonsync1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373311680-24414-1-git-send-email-neonsync1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 10:28:00PM +0300, Aldo Iljazi wrote:
> Specifically:
> n_gsm.c:810: ERROR: space required before the open parenthesis '('
> n_gsm.c:830: WARNING: line over 80 characters
> n_gsm.c:971: ERROR: trailing whitespace
> n_gsm.c:984: ERROR: code indent should use tabs where possible
> n_gsm.c:984: WARNING: please, no space before tabs
> n_gsm.c:984: WARNING: please, no spaces at the start of a line
> n_gsm.c:1141: WARNING: space prohibited before semicolon
> n_gsm.c:1743: ERROR: space required before the open brace '{'
> n_gsm.c:1744: WARNING: line over 80 characters
> n_gsm.c:1745: ERROR: code indent should use tabs where possible
> n_gsm.c:1746: ERROR: code indent should use tabs where possible
> n_gsm.c:2908: WARNING: line over 80 characters
> n_gsm.c:2912: ERROR: trailing whitespace
> 
> Signed-off-by: Aldo Iljazi <neonsync1@gmail.com>
> ---
>  drivers/tty/n_gsm.c |   29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 6422390..c0f76da 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -807,7 +807,7 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
>  	int h = dlci->adaption - 1;
>  
>  	total_size = 0;
> -	while(1) {
> +	while (1) {
>  		len = kfifo_len(dlci->fifo);
>  		if (len == 0)
>  			return total_size;
> @@ -827,8 +827,8 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
>  		switch (dlci->adaption) {
>  		case 1:	/* Unstructured */
>  			break;
> -		case 2:	/* Unstructed with modem bits. Always one byte as we never
> -			   send inline break data */
> +		case 2:	/* Unstructed with modem bits.
> +		Always one byte as we never send inline break data */
>  			*dp++ = gsm_encode_modem(dlci);
>  			break;
>  		}
> @@ -968,7 +968,7 @@ static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
>  	unsigned long flags;
>  	int sweep;
>  
> -	if (dlci->constipated) 
> +	if (dlci->constipated)
>  		return;
>  
>  	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
> @@ -981,7 +981,7 @@ static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
>  			gsm_dlci_data_output(dlci->gsm, dlci);
>  	}
>  	if (sweep)
> - 		gsm_dlci_data_sweep(dlci->gsm);
> +		gsm_dlci_data_sweep(dlci->gsm);
>  	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
>  }
>  
> @@ -1138,7 +1138,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, u8 *data, int clen)
>  static void gsm_control_rls(struct gsm_mux *gsm, u8 *data, int clen)
>  {
>  	struct tty_port *port;
> -	unsigned int addr = 0 ;
> +	unsigned int addr = 0;
>  	u8 bits;
>  	int len = clen;
>  	u8 *dp = data;
> @@ -1740,10 +1740,11 @@ static void gsm_queue(struct gsm_mux *gsm)
>  
>  	if ((gsm->control & ~PF) == UI)
>  		gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf, gsm->len);
> -	if (gsm->encoding == 0){
> -		/* WARNING: gsm->received_fcs is used for gsm->encoding = 0 only.
> -		            In this case it contain the last piece of data
> -		            required to generate final CRC */
> +	if (gsm->encoding == 0) {
> +		/* WARNING: gsm->received_fcs is used for
> +		gsm->encoding = 0 only.
> +		In this case it contain the last piece of data
> +		required to generate final CRC */
>  		gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
>  	}
>  	if (gsm->fcs != GOOD_FCS) {
> @@ -2904,9 +2905,11 @@ static int gsmtty_install(struct tty_driver *driver, struct tty_struct *tty)
>  	gsm = gsm_mux[mux];
>  	if (gsm->dead)
>  		return -EL2HLT;
> -	/* If DLCI 0 is not yet fully open return an error. This is ok from a locking
> -	   perspective as we don't have to worry about this if DLCI0 is lost */
> -	if (gsm->dlci[0] && gsm->dlci[0]->state != DLCI_OPEN) 
> +	/* If DLCI 0 is not yet fully open return an error.
> +	This is ok from a locking
> +	perspective as we don't have to worry about this
> +	if DLCI0 is lost */
> +	if (gsm->dlci[0] && gsm->dlci[0]->state != DLCI_OPEN)
>  		return -EL2NSYNC;
>  	dlci = gsm->dlci[line];
>  	if (dlci == NULL) {
> -- 
> 1.7.9.5
> 
