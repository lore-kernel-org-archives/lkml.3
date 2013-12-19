Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3LSEmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 23:42:11 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:39721 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3LSEmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 23:42:10 -0500
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTsoft Software Development Center
To: Rob Herring <robherring2@gmail.com>
Subject: Re: commit e38c0a1f breaks powerpc boards with uli1575 chip
Date: Thu, 19 Dec 2013 08:42:00 +0400
User-Agent: KMail/1.9.9
Cc: Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Alexey Lugovskoy <lugovskoy@dev.rtsoft.ru>,
        Dmitry Krivoschekov <dkrivoschokov@dev.rtsoft.ru>
References: <201312171135.38576@blacky.localdomain> <52B1EC15.5070606@gmail.com>
In-Reply-To: <52B1EC15.5070606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201312190842.02702@blacky.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reverting would break Tegra PCIe, but you should not have to change the
> DT either. So we need a solution.
>
> Is this something like this sufficient to fix it?
>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 4b9317b..378aebd 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -74,7 +74,7 @@ static u64 of_bus_default_map(__be32 *addr, const
> __be32 *range,
>          * mapping doesn't specify a physical address. Rather, the
> address * specifies an identifier that must match exactly.
>          */
> -       if (na > 2 && memcmp(range, addr, na * 4) != 0)
> +       if (na > 2 && memcmp(range, addr, (na - 2) * 4) != 0)
>                 return OF_BAD_ADDR;
>
>         if (da < cp || da >= (cp + s))


No, this does not help.

I've dumped the actual content of 'range' and 'addr' at the failure point 
(i.e. ar point that returns error with e38c0a1f but passes without 
e38c0a1f ):

OF: default map, cp=0, s=10000, da=70
range:  01 00 00 00 00 00 00 00 00 00 00 00
 addr:  00 00 00 00 00 00 00 00 00 00 00 70

Nikita
