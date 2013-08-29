Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3H2Svm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:51:42 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41062 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab3H2Svk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:51:40 -0400
MIME-Version: 1.0
In-Reply-To: <5217BCE1.4080101@wwwdotorg.org>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1507189.CRWvzVJqTV@flatron>
	<521548E3.6010703@wwwdotorg.org>
	<CACRpkdbVYfBS5L+0ejfbTBwPbD9HFB1kV8qnS7DdSydRccxDmg@mail.gmail.com>
	<52167A35.2010109@wwwdotorg.org>
	<CACRpkdYAjKhKC+Aaa4iQBXsJ46mgOta_SVztVyB=HZCGJD-b2g@mail.gmail.com>
	<5217BCE1.4080101@wwwdotorg.org>
Date: Thu, 29 Aug 2013 20:51:39 +0200
Message-ID: <CACRpkdYiV4e76j1N=m7YiK8ZvUAO69-=JkX6-su5T_DetwRK1Q@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 9:49 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/23/2013 12:38 PM, Linus Walleij wrote:

>> It can't be stopped but I consider it a bug if they do, as the proper
>> way to handle such GPIO lines is the sequence:
>>
>> request_gpio(gpio);
>> request_irq(gpio_to_irq(gpio));
>
> Back in the old days of ARM board files, there were many boards that
> didn't do this. I guess that doesn't make it any less of a bug, but it
> certainly implies to me that solving this in a way that caters to that
> bug being present will be a lot more useful.

I was more thinking along the lines of trying to avoid the
unpleasant lack of control when doing this with platform
data and hard-coded GPIO numbers by restricting the way
it can be done in the device tree.

Hoping that there were no offenders in there already ...
I guess it has to hit linux-next before we know that.

Yours,
Linus Walleij
