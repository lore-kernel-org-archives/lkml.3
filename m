Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3HVUxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:53:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49022 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3HVUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:53:15 -0400
Message-ID: <52167A35.2010109@wwwdotorg.org>
Date: Thu, 22 Aug 2013 14:53:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, galak@codeaurora.org,
        Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <1507189.CRWvzVJqTV@flatron> <521548E3.6010703@wwwdotorg.org> <CACRpkdbVYfBS5L+0ejfbTBwPbD9HFB1kV8qnS7DdSydRccxDmg@mail.gmail.com>
In-Reply-To: <CACRpkdbVYfBS5L+0ejfbTBwPbD9HFB1kV8qnS7DdSydRccxDmg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 05:27 PM, Linus Walleij wrote:
> On Thu, Aug 22, 2013 at 1:10 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On Wednesday 21 of August 2013 15:38:54 Lars Poeschel wrote:
> 
>>>> To solve this dilemma, perform an interrupt consistency check
>>>> when adding a GPIO chip: if the chip is both gpio-controller and
>>>> interrupt-controller, walk all children of the device tree,
>>
>> It seems a little odd to solve this only for DT. What about the non-DT case?
> 
> DT is the hardware configuration system that lets you request
> the same resource in two ways, i.e. it allows one and the same
> node to be both gpio-controller and interrupt-controller, and
> start handing out the same line as both GPIO and IRQ
> independently.

Huh? What stops systems using board files and platform data from having
this issue?
