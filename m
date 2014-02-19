Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaBSO7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:59:00 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:37979 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaBSO66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:58:58 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 09:58:58 EST
Date: Wed, 19 Feb 2014 09:54:36 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: solos-pci: make solos_bh() as static
Message-ID: <20140219095436.3db306a2@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1547067.MtNWZjBp8J@daeseok-laptop.cloud.net>
References: <1547067.MtNWZjBp8J@daeseok-laptop.cloud.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-0.001
X-NRLCMF-Virus-Scanned: No virus found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 14:13:54 +0900
Daeseok Youn <daeseok.youn@gmail.com> wrote:

> >From 6297aabeff748777b520cc0ee835af0a3ddc79e2 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Wed, 19 Feb 2014 10:49:12 +0900
> Subject: [PATCH] atm: solos-pci: make solos_bh() as static
> 
> sparse says:
> 
> drivers/atm/solos-pci.c:763:6: warning:
>  symbol 'solos_bh' was not declared. Should it be static?
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/atm/solos-pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
> index e3fb496..943cf0d 100644
> --- a/drivers/atm/solos-pci.c
> +++ b/drivers/atm/solos-pci.c
> @@ -760,7 +760,7 @@ static irqreturn_t solos_irq(int irq, void *dev_id)
>  	return IRQ_RETVAL(handled);
>  }
>  
> -void solos_bh(unsigned long card_arg)
> +static void solos_bh(unsigned long card_arg)
>  {
>  	struct solos_card *card = (void *)card_arg;
>  	uint32_t card_flags;

Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
