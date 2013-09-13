Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3IMPzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:55:17 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:43835 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3IMPzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
	<1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 13 Sep 2013 18:55:11 +0300
Message-ID: <CAHp75Vcec5MiGMUiusJhAmG6-R63OUZSXZPzafJzP6dC13Dgnw@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 6:14 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> GPIO operation regions is a new feature introduced in ACPI 5.0
> specification. In practise it means that now ASL code can toggle GPIOs with
> the help of the OS GPIO driver.

[]

>  void acpi_gpiochip_add(struct gpio_chip *chip)
>  {
> +       struct acpi_gpio_chip_data *data;
> +       acpi_handle handle;
> +       acpi_status status;
> +
> +       handle = ACPI_HANDLE(chip->dev);
> +       if (!handle)
> +               return;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);

May we use devm_kzalloc here?

-- 
With Best Regards,
Andy Shevchenko
