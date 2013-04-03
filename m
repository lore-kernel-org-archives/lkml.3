Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab3DCLKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:10:54 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46536 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab3DCLKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130402234648.8177.86213@quantum>
References: <1363603397-2762-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1364050010-23919-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130402234648.8177.86213@quantum>
Date: Wed, 3 Apr 2013 13:10:52 +0200
Message-ID: <CABJ1b_RtBtLP6jQ1wt8xuLKhvRG2jPr0zcgGWYeWQUUxTd3h7w@mail.gmail.com>
Subject: Re: [PATCH v4] clk: add si5351 i2c common clock driver
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 1:46 AM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Sebastian Hesselbarth (2013-03-23 07:46:50)
>> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
>> new file mode 100644
>> index 0000000..9d0c210
>> --- /dev/null
>> +++ b/drivers/clk/clk-si5351.c
>> @@ -0,0 +1,1411 @@
>> +/*
>> + * clk-si5351.c: Silicon Laboratories Si5351A/B/C I2C Clock Generator
>> + *
>> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> + * Rabeeh Khoury <rabeeh@solid-run.com>
>> + *
>> + * References:
>> + * [1] "Si5351A/B/C Data Sheet"
>> + *     http://www.silabs.com/Support%20Documents/TechnicalDocs/Si5351.pdf
>> + * [2] "Manually Generating an Si5351 Register Map"
>> + *     http://www.silabs.com/Support%20Documents/TechnicalDocs/AN619.pdf
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/clk-private.h>
>
> I hope that this is supposed to be clk-provider.h.  I don't plan on
> taking in any more clock drivers that depend on clk-private.h.  I didn't
> see any reason for this patch to not use clk-provider.h.

True except for two things:
- The driver sets clk flags for the hierarchy after parsing the DT and
there is no helper __clk_set_flags()
- For single parent clks (pxtal, pclkin) I reuse &clk->name for .parent_names

For the latter I would have to add two static char *[1] somewhere, not
a big deal. But the for the flags,
I guess there will be no __clk_set_flags helper? Then I'd have to
parse the DT in advance to have the
correct flags ready at clk registration.

Sebastian
