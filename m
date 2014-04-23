Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaDWP2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:28:04 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51492 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaDWP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:28:01 -0400
MIME-Version: 1.0
In-Reply-To: <1398265117-11793-8-git-send-email-balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
	<1398265117-11793-8-git-send-email-balbi@ti.com>
Date: Wed, 23 Apr 2014 12:27:59 -0300
Message-ID: <CAOMZO5AUn7FsUXbY4NBfkZyZUbRNm3hcP3DC6vOYHi89xbaVYw@mail.gmail.com>
Subject: Re: [PATCH 08/13] tty: serial: omap: switch over to platform_get_resource
From: Fabio Estevam <festevam@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>, gustavo@padovan.org,
        johan.hedberg@gmail.com, jslaby@suse.cz,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:58 AM, Felipe Balbi <balbi@ti.com> wrote:

> @@ -1658,12 +1657,9 @@ static int serial_omap_probe(struct platform_device *pdev)
>                 omap_up_info = of_get_uart_port_info(&pdev->dev);
>                 pdev->dev.platform_data = omap_up_info;
>         } else {
> -               irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -               if (!irq) {
> -                       dev_err(&pdev->dev, "no irq resource?\n");
> -                       return -ENODEV;
> -               }
> -               uartirq = irq->start;
> +               uartirq = platform_get_irq(pdev, 0);
> +               if (uartirq < 0)
> +                       return -EPROBE_DEFER;


Maybe you could just do a 'return uartirq' here instead.
