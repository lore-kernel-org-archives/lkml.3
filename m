Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaGKHrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:47:15 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:38326 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaGKHrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <1405064110-22579-9-git-send-email-varkabhadram@gmail.com>
References: <1405064110-22579-1-git-send-email-varkabhadram@gmail.com>
	<1405064110-22579-9-git-send-email-varkabhadram@gmail.com>
Date: Fri, 11 Jul 2014 09:47:09 +0200
X-Google-Sender-Auth: VfijKBa2pulaJPLl3MfmhB7Rq00
Message-ID: <CAMuHMdU97CTNENe4ktF2RWM6GBpPCV6hbqe_dByjDZXnFHw4_w@mail.gmail.com>
Subject: Re: [PATCH net-next 8/8] ethernet: amd: switch case fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: varkabhadram@gmail.com
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Thomas.Lendacky@amd.com,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Varka Bhadram <varkab@cdac.in>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 9:35 AM,  <varkabhadram@gmail.com> wrote:
> --- a/drivers/net/ethernet/amd/amd8111e.c
> +++ b/drivers/net/ethernet/amd/amd8111e.c
> @@ -197,23 +197,24 @@ static void amd8111e_set_ext_phy(struct net_device *dev)
>         advert = amd8111e_mdio_read(dev, lp->ext_phy_addr, MII_ADVERTISE);
>         tmp = advert & ~(ADVERTISE_ALL | ADVERTISE_100BASE4);
>         switch (lp->ext_phy_option) {
> -               default:

Behavior change from fall through and consider as auto-negotation...

> -               case SPEED_AUTONEG: /* advertise all values */
> -                       tmp |= (ADVERTISE_10HALF | ADVERTISE_10FULL |
> -                               ADVERTISE_100HALF | ADVERTISE_100FULL);
> -                       break;
> -               case SPEED10_HALF:
> -                       tmp |= ADVERTISE_10HALF;
> -                       break;
> -               case SPEED10_FULL:
> -                       tmp |= ADVERTISE_10FULL;
> -                       break;
> -               case SPEED100_HALF:
> -                       tmp |= ADVERTISE_100HALF;
> -                       break;
> -               case SPEED100_FULL:
> -                       tmp |= ADVERTISE_100FULL;
> -                       break;
> +       case SPEED_AUTONEG: /* advertise all values */
> +               tmp |= (ADVERTISE_10HALF | ADVERTISE_10FULL |
> +                       ADVERTISE_100HALF | ADVERTISE_100FULL);
> +               break;
> +       case SPEED10_HALF:
> +               tmp |= ADVERTISE_10HALF;
> +               break;
> +       case SPEED10_FULL:
> +               tmp |= ADVERTISE_10FULL;
> +               break;
> +       case SPEED100_HALF:
> +               tmp |= ADVERTISE_100HALF;
> +               break;
> +       case SPEED100_FULL:
> +               tmp |= ADVERTISE_100FULL;
> +               break;
> +       default:

... to do nothing.

> +               break;
>         }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
