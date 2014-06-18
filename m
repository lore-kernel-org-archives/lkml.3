Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbaFRH7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:59:39 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:45366 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbaFRH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <1403033788-8315-1-git-send-email-fabf@skynet.be>
References: <1403033788-8315-1-git-send-email-fabf@skynet.be>
Date: Wed, 18 Jun 2014 09:59:37 +0200
Message-ID: <CAGXE3d9aNXtOF3QTh99MU8FRPd0sdMP-d1Do6qYDJbTpdwcGUg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers/net/wireless/rt2x00/rt2x00dev.c: remove null
 test before kfree
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>, Ivo van Doorn <IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 17, 2014 at 9:36 PM, Fabian Frederick <fabf@skynet.be> wrote:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required

Thanks Fabian.
This should go through the wireless tree I guess, mind to send to
linux-wireless@vger.kernel.org?
Helmut

> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 2bde672..c2c2300 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1452,8 +1452,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>         /*
>          * Free the driver data.
>          */
> -       if (rt2x00dev->drv_data)
> -               kfree(rt2x00dev->drv_data);
> +       kfree(rt2x00dev->drv_data);
>  }
>  EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
>
> --
> 1.8.4.5
>
