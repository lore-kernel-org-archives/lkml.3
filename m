Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3EPPuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:50:51 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:58949 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab3EPPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:50:48 -0400
MIME-Version: 1.0
In-Reply-To: <1367616754-5142-1-git-send-email-geert@linux-m68k.org>
References: <1367616754-5142-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 16 May 2013 17:50:48 +0200
X-Google-Sender-Auth: TK4HYW8eGV6zVHfl2eYfbh2IbQQ
Message-ID: <CAMuHMdVq+nCOHCwhfWyuTgDniJgA8fkFVKvAuAoEAJEEv6hEHA@mail.gmail.com>
Subject: Re: [PATCH] of_net.h: Make of_get_phy_mode() return int i.s.o. const int
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 11:32 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> include/linux/of_net.h:16: warning: type qualifiers ignored on function return type
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  include/linux/of_net.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/of_net.h b/include/linux/of_net.h
> index 61bf53b..34597c8 100644
> --- a/include/linux/of_net.h
> +++ b/include/linux/of_net.h
> @@ -9,10 +9,10 @@
>
>  #ifdef CONFIG_OF_NET
>  #include <linux/of.h>
> -extern const int of_get_phy_mode(struct device_node *np);
> +extern int of_get_phy_mode(struct device_node *np);
>  extern const void *of_get_mac_address(struct device_node *np);
>  #else
> -static inline const int of_get_phy_mode(struct device_node *np)
> +static inline int of_get_phy_mode(struct device_node *np)
>  {
>         return -ENODEV;
>  }

drivers/of/of_net.c:41:11: error: conflicting types for 'of_get_phy_mode'
include/linux/of_net.h:12:12: note: previous declaration of
'of_get_phy_mode' was here

Doh, of course I also have to update the actual function in drivers/of/of_net.c.
Stay tuned for v2.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
