Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaHSJcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:32:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:35589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaHSJcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:32:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="470233173"
Date: Tue, 19 Aug 2014 12:32:44 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 1/2] gpio: acpi: normalize use of gpiochip_get_desc()
Message-ID: <20140819093244.GJ1660@lahna.fi.intel.com>
References: <1408380657-6718-1-git-send-email-acourbot@nvidia.com>
 <1408380657-6718-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408380657-6718-2-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 09:50:56AM -0700, Alexandre Courbot wrote:
> GPIO descriptors are changing from unique and permanent tokens to
> allocated resources. Therefore gpiochip_get_desc() cannot be used as a
> way to obtain a global GPIO descriptor anymore.
> 
> This patch updates the gpiolib ACPI support code to keep and use the
> descriptor returned by a centralized call to gpiochip_get_desc().
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpio/gpiolib-acpi.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index d62eaaa75397..9596a1023579 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -25,10 +25,12 @@ struct acpi_gpio_event {
>  	acpi_handle handle;
>  	unsigned int pin;
>  	unsigned int irq;
> +	gpio_desc *desc;

This needs to be 
	struct gpio_desc *desc;

>  };

Tested on Asus T100TA and nothing seems to break, so:

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
