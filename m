Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbaGYOKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:10:03 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56153 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874AbaGYOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:10:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53D26537.9000203@roeck-us.net>
Date: Fri, 25 Jul 2014 07:09:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: jiri.prchal@aksignal.cz, Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH] gpiolib: Provide and export gpiod_export_name
References: <1406139132-5404-1-git-send-email-linux@roeck-us.net> <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com> <53D0A7E4.1040707@aksignal.cz> <53D0A983.9000900@roeck-us.net> <53D20B6E.9010808@aksignal.cz>
In-Reply-To: <53D20B6E.9010808@aksignal.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 12:46 AM, Jiří Prchal wrote:
> What about this modification? If is defined label, use it prioritlly, at second use name in chip description.
>
> @@ -842,7 +842,9 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>       spin_unlock_irqrestore(&gpio_lock, flags);
>
>       offset = gpio_chip_hwgpio(desc);
> -    if (desc->chip->names && desc->chip->names[offset])
> +    if (desc->label)
> +        ioname = desc->label;
> +    else if (desc->chip->names && desc->chip->names[offset])
>           ioname = desc->chip->names[offset];
>

Label is not unique. It is, for example, used by the sysfs export function,
and all pins exported from user space have the same label. The first
pin exported through sysfs would be named "sysfs", the second export
would fail.

Guenter

