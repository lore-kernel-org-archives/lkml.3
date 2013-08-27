Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3H0Ui5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:38:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37473 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3H0Ui4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:38:56 -0400
Message-ID: <521D0E40.3010302@ti.com>
Date: Tue, 27 Aug 2013 16:38:24 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Lars Poeschel <larsi@wh2.tu-dresden.de>, <poeschel@lemonage.de>,
        <grant.likely@linaro.org>, <linus.walleij@linaro.org>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <galak@codeaurora.org>,
        <pawel.moll@arm.com>, <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <521D0964.2080209@wwwdotorg.org>
In-Reply-To: <521D0964.2080209@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 August 2013 04:17 PM, Stephen Warren wrote:
> On 08/26/2013 08:07 AM, Lars Poeschel wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> Currently the kernel is ambigously treating GPIOs and interrupts
>> from a GPIO controller: GPIOs and interrupts are treated as
>> orthogonal. This unfortunately makes it unclear how to actually
>> retrieve and request a GPIO line or interrupt from a GPIO
>> controller in the device tree probe path.
> 
> I still think that this patch is the wrong approach. Instead, the logic
> should be hooked into gpio_request() and request_irq(). This patch only
> addresses DT, and ignores anything else, hence doesn't seem like the
> right level of abstraction to plug in, since the issue is not related to DT.
> 
On the issue, Rajendra cooked up a patch [1] to handle the issue at
irqdomain level which was shot down after further discussion. It might
be useful for the discussion here. Ofcourse it was also targeted to
solve only DT issue.

Regards,
Santosh

[1]
"[PATCH] irqdomain: Do a gpio_request in case of a gpio irq_chip"
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg83451.html


