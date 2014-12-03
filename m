Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaLCKoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:44:21 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:64801 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLCKoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:44:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, heiko@sntech.de,
        Linus Walleij <linus.walleij@linaro.org>, tomasz.figa@gmail.com,
        Rob Herring <robh+dt@kernel.org>, thomas.ab@samsung.com,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/2] soc: samsung: add exynos chipid driver support
Date: Wed, 03 Dec 2014 11:43:24 +0100
Message-ID: <19026872.NZqUJn3Abb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417594658-2931-2-git-send-email-pankaj.dubey@samsung.com>
References: <1417594658-2931-1-git-send-email-pankaj.dubey@samsung.com> <1417594658-2931-2-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4rBY2UcmLkpUSdEf6hjYbLAiTAk6Q5V2nhINA1GDYC+
 wklMgE9h9cLfbV0vMbrPytfP6qgdNfP6Oueyu6vzXyyeuBSDRg
 BCf7et9dsz7A2LwJ3NWvRI4k0FGF+VtjxYQix5XUYZSkYBEU+E
 ORt12iAhTDUrbauBfmu6Z0oP8Px2CYLW9bBFFQk7EvXEYG0/G6
 6Zgh0IDLVLtmIYf5+VWVFvTgaKW3iJmarl1gqtdTyxq9zxZ15R
 QMSDM8CrcocCV4JmdYaJFMg046bgsFq0XvnaI/8OGg5r4JRtP5
 ICqUSAb5/W2mqgMnaYiMsbjfq5On0ZC+IFYP/aXm7g+/kenT8W
 6WndHSSfHp9YVgwr3gxQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Exynos SoCs have Chipid, for identification of product IDs
> and SoC revisions. This patch intendes to provide initialization
> code for all these functionalites, at the same time it provides some
> sysfs entries for accessing these information to userspace.
> 
> This driver usese existing binding for exnos-chipid.

Nice!

On Wednesday 03 December 2014 13:47:37 Pankaj Dubey wrote:

> +       soc_dev_attr->soc_id = exynos_product_id_to_name(soc_product_id);
> +
> +       soc_dev = soc_device_register(soc_dev_attr);
> +       if (IS_ERR(soc_dev))
> +               goto free_rev;
> +
> +       device_create_file(soc_device_to_device(soc_dev), &exynos_product_attr);
> +       device_create_file(soc_device_to_device(soc_dev),
> +                               &exynos_main_rev_attr);
> +       device_create_file(soc_device_to_device(soc_dev), &exynos_sub_rev_attr);
> +

I don't like the idea of having three extra nonstandard properties here,
especially when you are not using the machine field for anything useful.

Also, all three of these just come from the same register, why expose
them all as the machine and revision standard properties.

	Arnd
