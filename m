Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3BKAAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:00:22 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34265 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3BKAAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:00:21 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 3/6] of_spi: Initialize cs_gpios properly
To: Andreas Larsson <andreas@gaisler.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1359471223-4794-4-git-send-email-andreas@gaisler.com>
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com> <1359471223-4794-4-git-send-email-andreas@gaisler.com>
Date: Mon, 11 Feb 2013 00:00:06 +0000
Message-Id: <20130211000006.604D33E0C13@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 15:53:40 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> Using memset does not set an array of integers properly
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 9c2acf1..a4baa0a 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1083,7 +1083,8 @@ static int of_spi_register_master(struct spi_master *master)
>  	if (!master->cs_gpios)
>  		return -ENOMEM;
>  
> -	memset(cs, -EINVAL, master->num_chipselect);
> +	for (i = 0; i < master->num_chipselect; i++)
> +		cs[i] = -EINVAL;
>  
>  	for (i = 0; i < nb; i++)
>  		cs[i] = of_get_named_gpio(np, "cs-gpios", i);
> -- 
> 1.7.0.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
