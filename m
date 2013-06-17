Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3FQNro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:47:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54323 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3FQNrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:47:43 -0400
Date: Mon, 17 Jun 2013 15:47:41 +0200
From: Pavel Machek <pavel@denx.de>
To: dzu@denx.de, hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow binding drivers/uio/uio_pdrv_genirq.c to devices
 using command line option
Message-ID: <20130617134741.GA15547@amd.pavel.ucw.cz>
References: <20130412184335.GA5510@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412184335.GA5510@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This adds ability to bind uio driver to given open firmware device
> using command line option. Thus, userspace driver can be developed and
> used without modifying the kernel.
> 
> Signed-off-by: Pavel Machek <pavel@denx.de> 

Ping? Greg, could you apply this patch? Or is there someone else I
should ask to apply it?

								Pavel

> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index c122bca..8fcc2c7 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -264,9 +275,13 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
>  
>  #ifdef CONFIG_OF
>  static const struct of_device_id uio_of_genirq_match[] = {
> -	{ /* empty for now */ },
> +	{ /* This is filled with module_parm */ },
> +	{ /* Sentinel */ },
>  };
>  MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
> +
> +module_param_string(of_id, uio_of_genirq_match[0].compatible, 128, 0);
> +MODULE_PARM_DESC(of_id, "Openfirmware id of the device to be handled by uio");
>  #else
>  # define uio_of_genirq_match NULL
>  #endif
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
