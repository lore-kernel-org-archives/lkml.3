Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3FSTKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:10:43 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35027 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab3FSTKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:10:42 -0400
MIME-Version: 1.0
In-Reply-To: <1371205241-17205-3-git-send-email-avinashphilipk@gmail.com>
References: <1371203020-15092-1-git-send-email-avinashphilip@ti.com>
	<1371205241-17205-3-git-send-email-avinashphilipk@gmail.com>
Date: Wed, 19 Jun 2013 21:10:40 +0200
Message-ID: <CACRpkdbJJVKC539CAPNxxEbofVfw3Pr0gyCSZyY9YbkXneE-qQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] gpio: davinci: DT changes for driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilipk@gmail.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Philip Avinash <avinashphilip@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:20 PM, Philip Avinash
<avinashphilipk@gmail.com> wrote:

> From: KV Sujith <sujithkv@ti.com>
>
> - Add of_device_id for Davinci GPIO driver.
> - Add function to populate data from DT.
> - Modify the probe to read from DT if DT match is found.
> - Add DT binding documentation for Davinci GPIO properties in a new file
>   gpio-davinci.txt located at Documentation/devicetree/bindings/gpio/.
>
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes since v1:
>         - description for interrupts changed to reflecti
>            interrupt array usage.
(...)

> +static struct davinci_gpio_platform_data *davinci_gpio_set_pdata_of(
> +                                               struct platform_device *pdev)
> +{
> +       struct device_node *dn = pdev->dev.of_node;
> +       struct davinci_gpio_platform_data *pdata;
> +       u32 val, ret;
> +
> +       pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +       if (pdata) {

Instead of this arrow pattern:

if (!pdata) {
  dev_err( ... "out of memory allocating platform data");
  return NULL;
}

And de-indent the rest.

With that change:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess this may go through the DaVinci tree with the rest of the DaVinci
patches?

Yours,
Linus Walleij
