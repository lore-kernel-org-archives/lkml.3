Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3DBXq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:46:58 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47746 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3DBXq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:46:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1364050010-23919-1-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1363603397-2762-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1364050010-23919-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20130402234648.8177.86213@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH v4] clk: add si5351 i2c common clock driver
Date: Tue, 02 Apr 2013 16:46:48 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2013-03-23 07:46:50)
> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
> new file mode 100644
> index 0000000..9d0c210
> --- /dev/null
> +++ b/drivers/clk/clk-si5351.c
> @@ -0,0 +1,1411 @@
> +/*
> + * clk-si5351.c: Silicon Laboratories Si5351A/B/C I2C Clock Generator
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + * Rabeeh Khoury <rabeeh@solid-run.com>
> + *
> + * References:
> + * [1] "Si5351A/B/C Data Sheet"
> + *     http://www.silabs.com/Support%20Documents/TechnicalDocs/Si5351.pdf
> + * [2] "Manually Generating an Si5351 Register Map"
> + *     http://www.silabs.com/Support%20Documents/TechnicalDocs/AN619.pdf
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/clk-private.h>

I hope that this is supposed to be clk-provider.h.  I don't plan on
taking in any more clock drivers that depend on clk-private.h.  I didn't
see any reason for this patch to not use clk-provider.h.

Regards,
Mike
