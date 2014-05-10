Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaEJMS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 08:18:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59326 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750878AbaEJMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 08:18:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 1/1 RESEND] drivers/pnp/resource.c: remove positive test on unsigned values
Date: Sat, 10 May 2014 14:35:38 +0200
Message-ID: <9287733.QVZt9YArIy@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140510124715.e3b574aae4c8dafb0c9aefdd@skynet.be>
References: <20140510124715.e3b574aae4c8dafb0c9aefdd@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 10, 2014 12:47:15 PM Fabian Frederick wrote:
> irq and dma are both resource_size_t (derived from phys_addr_t <-> unsigned)
> 
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Queued up for 3.16, thanks!

> ---
>  drivers/pnp/resource.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
> index 01712cb..782e822 100644
> --- a/drivers/pnp/resource.c
> +++ b/drivers/pnp/resource.c
> @@ -360,7 +360,7 @@ int pnp_check_irq(struct pnp_dev *dev, struct resource *res)
>  		return 1;
>  
>  	/* check if the resource is valid */
> -	if (*irq < 0 || *irq > 15)
> +	if (*irq > 15)
>  		return 0;
>  
>  	/* check if the resource is reserved */
> @@ -424,7 +424,7 @@ int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
>  		return 1;
>  
>  	/* check if the resource is valid */
> -	if (*dma < 0 || *dma == 4 || *dma > 7)
> +	if (*dma == 4 || *dma > 7)
>  		return 0;
>  
>  	/* check if the resource is reserved */
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
