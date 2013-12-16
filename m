Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3LPLLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:11:03 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57377 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3LPLLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:11:01 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 16 Dec 2013 03:10:53 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/2] drivers: tty: Mark the functions as static in n_gsm.c
Message-ID: <20131216111052.GA23211@leaf>
References: <0d40902c95942d272a70b1d85b4e311d0cc7afa4.1387191158.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0d40902c95942d272a70b1d85b4e311d0cc7afa4.1387191158.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 04:28:24PM +0530, Rashika Kheria wrote:
> Marks the functions gsm_cleanup_mux(), gsm_activate_mux(),
> gsm_free_mux(), gsm_alloc_mux() and gsm_change_mtu() as static in
> n_gsm.c because they are not used outside this file.
> 
> Also, drop the EXPORT_SYMBOL_GPL for the above mentioned functions
> because nothing else in the kernel calls them.
> 
> This eliminates the following warnings in n_gsm.c:
> drivers/tty/n_gsm.c:2022:6: warning: no previous prototype for ‘gsm_cleanup_mux’ [-Wmissing-prototypes]
> drivers/tty/n_gsm.c:2076:5: warning: no previous prototype for ‘gsm_activate_mux’ [-Wmissing-prototypes]
> drivers/tty/n_gsm.c:2120:6: warning: no previous prototype for ‘gsm_free_mux’ [-Wmissing-prototypes]
> drivers/tty/n_gsm.c:2156:17: warning: no previous prototype for ‘gsm_alloc_mux’ [-Wmissing-prototypes]
> drivers/tty/n_gsm.c:2714:5: warning: no previous prototype for ‘gsm_change_mtu’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/tty/n_gsm.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index c0f76da..6ca9fbb 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -2019,7 +2019,7 @@ static void gsm_error(struct gsm_mux *gsm,
>   *	and then shut down each device hanging up the channels as we go.
>   */
>  
> -void gsm_cleanup_mux(struct gsm_mux *gsm)
> +static void gsm_cleanup_mux(struct gsm_mux *gsm)
>  {
>  	int i;
>  	struct gsm_dlci *dlci = gsm->dlci[0];
> @@ -2062,7 +2062,6 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
>  		kfree(txq);
>  	INIT_LIST_HEAD(&gsm->tx_list);
>  }
> -EXPORT_SYMBOL_GPL(gsm_cleanup_mux);
>  
>  /**
>   *	gsm_activate_mux	-	generic GSM setup
> @@ -2073,7 +2072,7 @@ EXPORT_SYMBOL_GPL(gsm_cleanup_mux);
>   *	finally kick off connecting to DLCI 0 on the modem.
>   */
>  
> -int gsm_activate_mux(struct gsm_mux *gsm)
> +static int gsm_activate_mux(struct gsm_mux *gsm)
>  {
>  	struct gsm_dlci *dlci;
>  	int i = 0;
> @@ -2109,7 +2108,6 @@ int gsm_activate_mux(struct gsm_mux *gsm)
>  	gsm->dead = 0;		/* Tty opens are now permissible */
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(gsm_activate_mux);
>  
>  /**
>   *	gsm_free_mux		-	free up a mux
> @@ -2117,13 +2115,12 @@ EXPORT_SYMBOL_GPL(gsm_activate_mux);
>   *
>   *	Dispose of allocated resources for a dead mux
>   */
> -void gsm_free_mux(struct gsm_mux *gsm)
> +static void gsm_free_mux(struct gsm_mux *gsm)
>  {
>  	kfree(gsm->txframe);
>  	kfree(gsm->buf);
>  	kfree(gsm);
>  }
> -EXPORT_SYMBOL_GPL(gsm_free_mux);
>  
>  /**
>   *	gsm_free_muxr		-	free up a mux
> @@ -2153,7 +2150,7 @@ static inline void mux_put(struct gsm_mux *gsm)
>   *	Creates a new mux ready for activation.
>   */
>  
> -struct gsm_mux *gsm_alloc_mux(void)
> +static struct gsm_mux *gsm_alloc_mux(void)
>  {
>  	struct gsm_mux *gsm = kzalloc(sizeof(struct gsm_mux), GFP_KERNEL);
>  	if (gsm == NULL)
> @@ -2185,7 +2182,6 @@ struct gsm_mux *gsm_alloc_mux(void)
>  
>  	return gsm;
>  }
> -EXPORT_SYMBOL_GPL(gsm_alloc_mux);
>  
>  /**
>   *	gsmld_output		-	write to link
> @@ -2711,7 +2707,7 @@ static void gsm_mux_rx_netchar(struct gsm_dlci *dlci,
>  	return;
>  }
>  
> -int gsm_change_mtu(struct net_device *net, int new_mtu)
> +static int gsm_change_mtu(struct net_device *net, int new_mtu)
>  {
>  	struct gsm_mux_net *mux_net = (struct gsm_mux_net *)netdev_priv(net);
>  	if ((new_mtu < 8) || (new_mtu > mux_net->dlci->gsm->mtu))
> -- 
> 1.7.9.5
> 
