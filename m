Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3ITTVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:21:41 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35223 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3ITTVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
	<1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 20 Sep 2013 21:21:37 +0200
Message-ID: <CACRpkdb5fqMycTxou50-+oiNOs3vzd+8XfWsPbX8vBJp2Su3aw@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 5:14 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
(...)
> +struct acpi_gpio_chip_data {
> +       /*
> +        * acpi_install_address_space_handler() wants to put the connection
> +        * information at the start of the context structure we pass it, in
> +        * case we are dealing with GPIO operation regions.
> +        */
> +       struct acpi_connection_info ci;
> +       struct gpio_chip *chip;
> +       struct list_head *evt_pins;
> +};

Consider just naming this acpi_gpio_chip, as it is obviously some
generic container that you will keep adding to.

I'm uncertain how things work, it wouldn't add something to have
struct gpio_chip be a true member (not a pointer) so you can
allocate one thing from the drivers, and e.g. use container_of()
to get from the gpio_chip to the acpi_gpio_chip[_data]?

Yours,
Linus Walleij
