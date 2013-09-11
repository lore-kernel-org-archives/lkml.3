Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3IKRPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:15:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46176 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3IKRPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <1378901968-7368-1-git-send-email-broonie@kernel.org>
References: <1378901968-7368-1-git-send-email-broonie@kernel.org>
Date: Wed, 11 Sep 2013 14:15:51 -0300
Message-ID: <CACnwZYeNe4T27eqiQ+LW-ot9Hk8Qk0Uzg7b3jH7xF_euHOWYhQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Split devres code out into a separate file
From: Thiago Farina <tfransosi@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        linux list <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 9:19 AM, Mark Brown <broonie@kernel.org> wrote:
> From: Mark Brown <broonie@linaro.org>
>
> Cut down on the size of core.c a bit more and ensure that the devres
> versions of things don't do too much peering inside the internals of
> the APIs they wrap.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/regulator/Makefile   |   2 +-
>  drivers/regulator/core.c     | 252 +------------------------------------------
>  drivers/regulator/devres.c   | 252 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/regulator/internal.h |  38 +++++++
>  4 files changed, 292 insertions(+), 252 deletions(-)
>  create mode 100644 drivers/regulator/devres.c
>  create mode 100644 drivers/regulator/internal.h
> diff --git a/drivers/regulator/internal.h b/drivers/regulator/internal.h
> new file mode 100644
> index 0000000..84bbda1
> --- /dev/null
> +++ b/drivers/regulator/internal.h
> @@ -0,0 +1,38 @@
> +/*
> + * internal.h  --  Voltage/Current Regulator framework internal code
> + *
> + * Copyright 2007, 2008 Wolfson Microelectronics PLC.
> + * Copyright 2008 SlimLogic Ltd.
> + *
> + * Author: Liam Girdwood <lrg@slimlogic.co.uk>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#ifndef __REGULATOR_INTERNAL_H
> +#define __REGULATOR_INTERNAL_H
> +
> +/*
> + * struct regulator
> + *
> + * One for each consumer device.
> + */
> +struct regulator {
> +       struct device *dev;
> +       struct list_head list;
> +       unsigned int always_on:1;
> +       unsigned int bypass:1;
> +       int uA_load;
> +       int min_uV;
> +       int max_uV;
> +       char *supply_name;
> +       struct device_attribute dev_attr;
> +       struct regulator_dev *rdev;
> +       struct dentry *debugfs;
> +};
> +
don't you need any forward declaration here nor any include (like for
list_head and device_attribute)?

--
Thiago
