Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3AYJrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:47:49 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:57642 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3AYJrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:47:45 -0500
MIME-Version: 1.0
In-Reply-To: <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	<3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
Date: Fri, 25 Jan 2013 10:47:45 +0100
Message-ID: <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Linus Walleij <linus.walleij@linaro.org>
To: Aaron Sierra <asierra@xes-inc.com>, Paul Bolle <pebolle@tiscali.nl>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 9:52 PM, Aaron Sierra <asierra@xes-inc.com> wrote:

> In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
> offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
> properly be enabled (and disabled) for these chipsets.
>
> Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>

OK... Paul, can you test this on your setup?

> @@ -858,14 +874,35 @@ wdt_done:
>  static int lpc_ich_probe(struct pci_dev *dev,
>                                 const struct pci_device_id *id)
>  {
> +       struct lpc_ich_priv *priv;
>         int ret;
>         bool cell_added = false;
>
> -       ret = lpc_ich_init_wdt(dev, id);
> +       priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
> +       if (!priv)
> +               return -ENOMEM;
> +
> +       priv->chipset = id->driver_data;

So where is this id->driver_data which is just assigned to
priv->chipset coming from again? ACPI something?

Just trying to follow things...

Yours,
Linus Walleij
