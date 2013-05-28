Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab3E1G1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:27:39 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44842 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab3E1G1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <1369417304.9205.1.camel@phoenix>
References: <1369417304.9205.1.camel@phoenix>
Date: Tue, 28 May 2013 11:57:37 +0530
Message-ID: <CAK7N6vr9Jynd0ezXTRb8spGtxAKsRnrYGOtgTiYMPDDz_u1vMA@mail.gmail.com>
Subject: Re: [PATCH] power_supply: generic-adc-battery: Fix checking if none
 of the channels are supported
From: anish singh <anish198519851985@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 11:11 PM, Axel Lin <axel.lin@ingics.com> wrote:
> If none of the channels are supported, index is 0.
> Also ensure to return error code instead of 0 in goto second_mem_fail path.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: anish kumar <anish198519851985@gmail.com>

I think anton would have already picked up.
> ---
>  drivers/power/generic-adc-battery.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
> index 8cb5d7f..59a1421 100644
> --- a/drivers/power/generic-adc-battery.c
> +++ b/drivers/power/generic-adc-battery.c
> @@ -299,8 +299,10 @@ static int gab_probe(struct platform_device *pdev)
>         }
>
>         /* none of the channels are supported so let's bail out */
> -       if (index == ARRAY_SIZE(gab_chan_name))
> +       if (index == 0) {
> +               ret = -ENODEV;
>                 goto second_mem_fail;
> +       }
>
>         /*
>          * Total number of properties is equal to static properties
> --
> 1.8.1.2
>
>
>
