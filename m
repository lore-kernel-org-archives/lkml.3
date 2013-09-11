Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3IKHgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:36:33 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45629 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3IKHgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:36:31 -0400
Message-ID: <52301D6B.70305@ahsoftware.de>
Date: Wed, 11 Sep 2013 09:36:11 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: joelf@ti.com
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <51F8CC35.1070704@collabora.co.uk> <522EC392.8070002@ti.com> <522F1BF0.8080608@collabora.co.uk> <522F3408.6050608@ti.com> <52301655.6080801@ahsoftware.de> <523018DB.7080004@ahsoftware.de> <52301C13.2030103@ahsoftware.de>
In-Reply-To: <52301C13.2030103@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.09.2013 09:30, schrieb Alexander Holler:
> And another small update. ;)
>
> Am 11.09.2013 09:16, schrieb Alexander Holler:
>
>>> To summarize what happens if a driver uses a gpio as irq:
>>>
>>> gpio_request() // This works only if the gpio was not requested before
>>> gpio_direction_input()
>>> gpio_to_irq() // This needs an irq-mapping
>>> request_threaded_irq()
>>>
>>> So I would suggest multiple steps to change that:
>>>
>>> 1. Create a mapping for every gpio found in DT (or all gpios if no DT is
>>> used). I think that is what Linus patch does (sorry, I haven't really
>>> followed this thread and didn't look in deep at the patch).
>>>
>>> 2. Implement gpio_request_for_irq()
>>> This would just be a small macro for gpio_request();
>>> gpio_direction_input()
>>>
>
> I would add gpio_to_irq() to that macro, so that it returns the irq
> number or zero if something failed.

Doing that, it would be easy to mark gpio_to_irq() as deprecated and 
driver authors would change automatically to use gpio_request_for_irq()
(or gpio_request_as_irq() which might more correct english).

So I would suggest just the two steps above, the first with the mapping 
and the second which introduces gpio_request_as_irq() and marks 
gpio_to_irq() as deprecated.

Everthing else I would leave out for the future (so I wouldn't request 
gpios centrally).

Regards,

Alexander Holler

