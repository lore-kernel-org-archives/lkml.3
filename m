Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaLDOZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:25:38 -0500
Received: from h1.radempa.de ([176.9.142.194]:54554 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbaLDOZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:25:37 -0500
From: Harald Geyer <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] iio: dht11: Logging updates
In-reply-to: <547F80E0.3020001@nod.at>
References: <1417563176-31972-1-git-send-email-richard@nod.at> <1417563176-31972-4-git-send-email-richard@nod.at> <E1Xw9W8-0001Db-9a@stardust.g4.wien.funkfeuer.at> <547F0BE5.2050808@nod.at> <E1XwAQO-0001HP-9x@stardust.g4.wien.funkfeuer.at> <547F80E0.3020001@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Wed, 03 Dec 2014 22:30:08 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4160.1417703106.1@stardust.g4.wien.funkfeuer.at>
Date: Thu, 04 Dec 2014 15:25:06 +0100
Message-Id: <E1XwXL8-000158-49@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger writes:
> Am 03.12.2014 um 14:56 schrieb Harald Geyer:
> > Richard Weinberger writes:
> >> Am 03.12.2014 um 13:58 schrieb Harald Geyer:
> >> Currently we get log messages of style:
> >> "iio iio:deviceX: foo bar"
> >> and:
> >> "dht11 <name in DT>: foo bar"
> >>
> >> I really favorite "dht11 <name in DT".
> >> In my device tree every senor has a sane name and log messages look like:
> >> "dht11 toiletten sensor: invalid checksum"
> > 
> > I think I ACKed the one with "iio iio:deviceX: foo bar"? 
> 
> No, my patch turns all logs to "dht11 <name in DT>: foo bar".

Maybe I was unclear. AFAICS there is one case where we actually have
"iio iio:deviceX: foo bar" now and I said:

> @@ -193,7 +197,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>               free_irq(dht11->irq, iio_dev);
>
>               if (ret == 0 && dht11->num_edges < DHT11_EDGES_PER_READ - 1) {
> -                     dev_err(&iio_dev->dev,
> +                     dev_err(dht11->dev,

Ack.

Hope that clarifies,
Harald
