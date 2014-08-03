Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaHCKpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 06:45:06 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:3949 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbaHCKpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 06:45:04 -0400
X-IronPort-AV: E=Sophos;i="5.01,792,1400018400"; 
   d="scan'208";a="73810216"
Date: Sun, 3 Aug 2014 12:45:00 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Jonathan Cameron <jic23@kernel.org>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: ad9832: Use devm_iio_device_register
In-Reply-To: <2af09d4e-10c7-4887-a29c-0d31b0ac6493@email.android.com>
Message-ID: <alpine.DEB.2.02.1408031243500.2000@localhost6.localdomain6>
References: <20140803095658.GA6753@himangi-Dell> <2af09d4e-10c7-4887-a29c-0d31b0ac6493@email.android.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Aug 2014, Jonathan Cameron wrote:

> 
> 
> On August 3, 2014 10:56:58 AM GMT+01:00, Himangi Saraogi <himangi774@gmail.com> wrote:
> >This patch introduces the use of devm_iio_device_register and does away
> >with the unregister in the remove function.
> >
> And changes the resulting ordering so the regulator disable occurs before the user
>  space interface has been removed by the unregister. 
> 
> Please be very wary of using devm_iio_register. It is only correct if the remove function does nothing else.

I wonder if there could be a way to document these constraints?

julia

> Jonathan
> >Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> >Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> >---
> > drivers/staging/iio/frequency/ad9832.c | 3 +--
> > 1 file changed, 1 insertion(+), 2 deletions(-)
> >
> >diff --git a/drivers/staging/iio/frequency/ad9832.c
> >b/drivers/staging/iio/frequency/ad9832.c
> >index cf68159..8a72c78 100644
> >--- a/drivers/staging/iio/frequency/ad9832.c
> >+++ b/drivers/staging/iio/frequency/ad9832.c
> >@@ -304,7 +304,7 @@ static int ad9832_probe(struct spi_device *spi)
> > 	if (ret)
> > 		goto error_disable_reg;
> > 
> >-	ret = iio_device_register(indio_dev);
> >+	ret = devm_iio_device_register(&spi->dev, indio_dev);
> > 	if (ret)
> > 		goto error_disable_reg;
> > 
> >@@ -322,7 +322,6 @@ static int ad9832_remove(struct spi_device *spi)
> > 	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> > 	struct ad9832_state *st = iio_priv(indio_dev);
> > 
> >-	iio_device_unregister(indio_dev);
> > 	if (!IS_ERR(st->reg))
> > 		regulator_disable(st->reg);
> > 
> 
> -- 
> Sent from my Android phone with K-9 Mail. Please excuse my brevity.
> 
