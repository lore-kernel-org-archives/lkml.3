Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaBJOFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:05:49 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:33700 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaBJOFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:05:46 -0500
Date: Mon, 10 Feb 2014 14:05:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] mfd: MAX6650/6651 support
Message-ID: <20140210140540.GB23141@lee--X1>
References: <1392019497-12440-1-git-send-email-lpapp@kde.org>
 <20140210112242.GB21522@lee--X1>
 <CAOMwXhMJTeO8ev++dzXKtz8En9pK+3CkjmweuLsb5aoU+e=Aqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhMJTeO8ev++dzXKtz8En9pK+3CkjmweuLsb5aoU+e=Aqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +static struct mfd_cell max665x_devs[] = {
> >> +     { .name = "max6651-gpio", },
> >> +     { .name = "max6650", }, /* hwmon driver */
> >
> > What happened to renaming the hwmon driver, so we can have
> > "max6650-hwmon" here?
> 
> I will add the alias in the next patch (e.g. hwmon change). I can come
> back to this and rename then.

Better add this patch _after_ that change. That will prevent any
inherently awkward to handing 'cross subsystem' patches.

> >> +static const struct i2c_device_id max665x_id[] = {
> >> +     { "max6650", TYPE_MAX6650 },
> >> +     { "max6651", TYPE_MAX6651 },
> >> +     {},
> >
> > Can you remind me where these IDs are being used?
> 
> Strictly speaking, not in this change, so I can remove it and add
> later if needed.

Please remove them if they're not being used.

> >> +};
> >> +MODULE_DEVICE_TABLE(i2c, max665x_id);
> >> +
> >> +static struct i2c_driver max665x_driver = {
> >> +     .driver = {
> >> +             .name = "max665x",
> >> +             .owner = THIS_MODULE,
> >
> > All new drivers are required to support Device Tree.
> 
> Do you have some recommendation for documentation, examples, etc? I am
> new to this.

Documentation/devicetree/usage-model.txt
Documentation/devicetree/bindings/mfd/*

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
