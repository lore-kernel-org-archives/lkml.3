Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab3D1SDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 14:03:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3D1SDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 14:03:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] clk: si5351: Allow to build without CONFIG_OF
Date: Sun, 28 Apr 2013 20:03:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        "Jean-Francois Moine" <moinejf@free.fr>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Michal Bachraty <michal.bachraty@streamunlimited.com>,
        Marek Belisko <marek.belisko@streamunlimited.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1367144681-14248-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1367144681-14248-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304282003.26593.arnd@arndb.de>
X-Provags-ID: V02:K0:nbtvSx+HbnITcxK2sEOUvdUd45SeR58ImCH0O0ua8I/
 FJVaXjZyJDlAAr194UTZxCio+J9KsF9XwG8dNsITQMOpCKVnmJ
 WAIq7sqkT2WU8dBji330nvdl5UcNkvrMK5BvZ0vpOkgU9+jyv9
 UxIePw7ZwAMilKw1iIFEhG1TkNbgV8bsaYIld5M0JVc+WibnWB
 eAqq6WuAjLHL1voPjqCGjjGFVnwv5h8wwwS01Ln2TuGS9kmmeJ
 b9cdbjs+3gswcGtvjcq4LwEx2eyeibq2lms2gI1Oc0de1JGyhJ
 UjqszZGt+8pz6aTCc4Awhv7OcenSmUb4K265DjBva8qsBquwqY
 VY235pKW5Ylr61lwRo5U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 April 2013, Sebastian Hesselbarth wrote:
> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
> index 8323c31..91c0f01 100644
> --- a/drivers/clk/clk-si5351.c
> +++ b/drivers/clk/clk-si5351.c
> @@ -1489,12 +1489,14 @@ static int si5351_i2c_probe(struct i2c_client *client,
>                 }
>         }
>  
> +#ifdef CONFIG_OF
>         ret = of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,
>                                   &drvdata->onecell);
>         if (ret) {
>                 dev_err(&client->dev, "unable to add clk provider\n");
>                 return ret;
>         }
> +#endif
>  

I think we should instead make of_clk_add_provider return 0 if CONFIG_OF
is disabled, adn we don't consider it an error condition to call it.
That is also what we return when CONFIG_OF is enabled and we boot without
a device tree.

	Arnd
