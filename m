Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3CGMar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:30:47 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42931 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3CGMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:30:46 -0500
MIME-Version: 1.0
In-Reply-To: <1362626815-6628-1-git-send-email-wenyou.yang@atmel.com>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
	<1362626815-6628-1-git-send-email-wenyou.yang@atmel.com>
Date: Thu, 7 Mar 2013 13:30:45 +0100
Message-ID: <CAGhQ9VwW18LXY5Jn0FUFCaAzKxP1W3QADG=JBp9JbgaAwo=F2Q@mail.gmail.com>
Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
 xfer->speed_hz set
From: Joachim Eastwood <manabian@gmail.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        richard.genoud@gmail.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2013 04:26, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> commit: 059b8ffeee5b427949872bb6ed5db5ae0788054e
> cause the atmel spi probing failure.
>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/spi/spi-atmel.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 656d137..1eca815 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -846,9 +846,9 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
>                         }
>                 }
>
> -               /* FIXME implement these protocol options!! */
> -               if (xfer->speed_hz) {
> -                       dev_dbg(&spi->dev, "no protocol options yet\n");
> +               if (xfer->speed_hz < spi->max_speed_hz) {
> +                       dev_dbg(&spi->dev,
> +                               "speed in transfer less than bus speed\n");
>                         return -ENOPROTOOPT;
>                 }

I sent a similar patch to spi-devl a while ago, which Grant said he applied.
https://patchwork.kernel.org/patch/2165301/

Can't find the patch in any upstream git tree so I guess Grant hasn't
pushed it yet.

regards
Joachim Eastwood
