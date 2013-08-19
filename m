Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab3HSTPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:15:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38694 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3HSTPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:15:46 -0400
Message-ID: <52126EDE.5060000@wwwdotorg.org>
Date: Mon, 19 Aug 2013 13:15:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v2] pinctrl: queue GPIO operations instead of defering
References: <1376751410-14560-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1376751410-14560-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 08:56 AM, Linus Walleij wrote:
> We currently defer probing of the caller if a pinctrl GPIO
> request or direction setting comes in before the range mapping
> a certain GPIO to a certain pin controller is available.
> 
> This can end up with a circular dependency: the GPIO driver
> needs the pin controller to be ready

So that much is explained above; it's because some GPIO APIs call into
pinctrl to manage GPIO-vs-pinmux-function setup.

> and the pin controller need the GPIO driver to be ready.

Why does that happen?

> This also happens if
> pin controllers and GPIO controllers compiled as modules
> are inserted in a certain order.

Shouldn't deferred probe resolve that just fine, assuming there are no
circular dependencies? In other words, this is just a special case of
the explanation above, so probably not worth explicitly mentioning.

...
> On the Nomadik we get this situation with the pinctrl
> driver when moving to requesting GPIOs off the gpiochip
> right after it has been added,

So, the pinctrl driver calls gpio_request()? Surely the solution is
simply not to do that?
