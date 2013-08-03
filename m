Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab3HCHYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 03:24:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:54471 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3HCHYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 03:24:37 -0400
Message-ID: <51FCAFFB.4000005@ahsoftware.de>
Date: Sat, 03 Aug 2013 09:23:39 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Linus Walleij <linus.walleij@linaro.org>,
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
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <51F8CC35.1070704@collabora.co.uk> <51FB8292.9090000@ahsoftware.de> <51FBD1CA.1000202@ahsoftware.de>
In-Reply-To: <51FBD1CA.1000202@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.08.2013 17:35, schrieb Alexander Holler:
> Am 02.08.2013 11:57, schrieb Alexander Holler:
> 
>> There must have been a bug in the patch too. I've also added that
>> iinterrupt-parent stuff (with the same flags as used by the driver) and
>> just have let the driver call
>>
>> request_threaded_irq(gpio_to_irq(gpio), flags);
>>
>> without the gpio_request()/input() before. And request_threaded_irq()

Thinking again about what I've tried, I might have make the failure to
add the interrupt-parent line to the mmc-section (where the gpio was
specified) and not to the gpio(-controller) section where it might have
belong too (again, there was no example and no documentation).

But why I again bother you all with another mail, is that I don't like
the fact that the irq-flags might have to be specified in the DT and the
source (and they have to match).

A solution might be to use the flags specified in the DT for the
particular irq and ignore the flags specified as parameter to
request_irq(). At least as long as DT isn't mandatory. And in the
future, the flags could just be removed from the call to request_irq()
depending (then visible too) only on the flags as specified in the DT.

Regards,

Alexander Holler

