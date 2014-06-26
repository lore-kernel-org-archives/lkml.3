Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbaFZSBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:01:00 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:40106 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaFZSA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:00:58 -0400
MIME-Version: 1.0
In-Reply-To: <1403681075-16181-1-git-send-email-voice.shen@atmel.com>
References: <1403681075-16181-1-git-send-email-voice.shen@atmel.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 26 Jun 2014 11:00:17 -0700
Message-ID: <CAGVrzcaN9KKW6vN5Xy775RTBD3ODpK95-o0V+pKDcCCxetPycA@mail.gmail.com>
Subject: Re: [RFC PATCH] phy: micrel: make phy_has_fixups attribute read correctly
To: Bo Shen <voice.shen@atmel.com>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014-06-25 0:24 GMT-07:00 Bo Shen <voice.shen@atmel.com>:
> If the fixups parameters get from dtb, it won't set has_fixups
> parameters, so when read phy_has_fixups attribute, it always
> present as 0.
> Add this patch to make phy_has_fixups attribute read correctly.

I am not entirely sure whether loading values from Device Tree should
be considered a PHY fixup per-se. They do override the hardware reset
default values, but I am not sure if we should consider that as a
fixup.

Assuming that you need to troubleshoot a given system, one of the
first things you will surely ask for is the DTS used by that platform,
and in that case you can quickly check whether the PHY default
settings are changed, right?

>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>  drivers/net/phy/micrel.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index bc7c7d2..c384922 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -237,6 +237,8 @@ static int ksz9021_load_values_from_of(struct phy_device *phydev,
>
>         if (!matches)
>                 return 0;
> +       else
> +               phydev->has_fixups = true;

There is no need for the else here

>
>         if (matches < 4)
>                 newval = kszphy_extended_read(phydev, reg);
> @@ -330,6 +332,8 @@ static int ksz9031_of_load_skew_values(struct phy_device *phydev,
>
>         if (!matches)
>                 return 0;
> +       else
> +               phydev->has_fixups = true;

Same here

>
>         if (matches < numfields)
>                 newval = ksz9031_extended_read(phydev, OP_DATA, 2, reg);
> --
> 1.8.5.2
>



-- 
Florian
