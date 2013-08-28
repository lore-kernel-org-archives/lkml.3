Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3H1TvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:51:02 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54812 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3H1TvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:51:00 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2] of_net.h: Make of_get_phy_mode() return int i.s.o. const int
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <1376823690-29179-1-git-send-email-geert@linux-m68k.org>
References: <1376823690-29179-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 28 Aug 2013 20:51:03 +0100
Message-Id: <20130828195103.1C90E3E0AF4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Aug 2013 13:01:30 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> include/linux/of_net.h:16: warning: type qualifiers ignored on function return type
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Applied, thanks.

g.

> v2: update the actual function in drivers/of/of_net.c.
> 
>  drivers/of/of_net.c    |    2 +-
>  include/linux/of_net.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
> index ea174c8..8f9be2e 100644
> --- a/drivers/of/of_net.c
> +++ b/drivers/of/of_net.c
> @@ -39,7 +39,7 @@ static const char *phy_modes[] = {
>   * The function gets phy interface string from property 'phy-mode',
>   * and return its index in phy_modes table, or errno in error case.
>   */
> -const int of_get_phy_mode(struct device_node *np)
> +int of_get_phy_mode(struct device_node *np)
>  {
>  	const char *pm;
>  	int err, i;
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
>  	return -ENODEV;
>  }
> -- 
> 1.7.9.5
> 

