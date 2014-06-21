Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaFUW7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 18:59:32 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50737 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaFUW7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 18:59:31 -0400
MIME-Version: 1.0
In-Reply-To: <1403382541-7129-1-git-send-email-linux@rainbow-software.org>
References: <1403382541-7129-1-git-send-email-linux@rainbow-software.org>
Date: Sat, 21 Jun 2014 15:59:30 -0700
Message-ID: <CAP6odjjE3hYXPggagPvF+hYm7nGHQqLqeQ3Ls9jzd=DVBLcJ4w@mail.gmail.com>
Subject: Re: [PATCH] tulip: Poll link status more frequently for Comet chips
From: Grant Grundler <grantgrundler@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
        "open list:TULIP NETWORK DRI..." <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ondrej,

On Sat, Jun 21, 2014 at 1:29 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> Poll link status every 2 seconds instead of 60 for ADMtek Comet chips.

Why use 2 seconds for the polling interval?

I'm sure you have a good reason for this and it should be in the
commit message or as a comment in the code.

I otherwise have no objection to this change.

thanks,
grant

> Tested with AN983B.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/net/ethernet/dec/tulip/timer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/dec/tulip/timer.c b/drivers/net/ethernet/dec/tulip/timer.c
> index 768379b..523d9dd 100644
> --- a/drivers/net/ethernet/dec/tulip/timer.c
> +++ b/drivers/net/ethernet/dec/tulip/timer.c
> @@ -158,7 +158,7 @@ void comet_timer(unsigned long data)
>  {
>         struct net_device *dev = (struct net_device *)data;
>         struct tulip_private *tp = netdev_priv(dev);
> -       int next_tick = 60*HZ;
> +       int next_tick = 2*HZ;
>
>         if (tulip_debug > 1)
>                 netdev_dbg(dev, "Comet link status %04x partner capability %04x\n",
> --
> Ondrej Zary
