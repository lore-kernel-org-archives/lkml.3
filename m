Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3FPKz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:55:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33794 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab3FPKzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <51BA4158.906@wwwdotorg.org>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
	<51AF73E9.90506@wwwdotorg.org>
	<CACRpkdY_s_RkErKLqVOWdE-A80CZOq7+VZSE8jcYSUbYkvsYYQ@mail.gmail.com>
	<51BA4158.906@wwwdotorg.org>
Date: Sun, 16 Jun 2013 12:55:25 +0200
Message-ID: <CACRpkda_tYONYU-N2M+j19A09iNP_dBWE8eBkOrL2LTrx42k_Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: pinctrl sleep and idle states in the core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:02 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/11/2013 02:28 AM, Linus Walleij wrote:
>> I tried to create a refactoring patch for this but couldn't come
>> up with anything apropriate along the lines above. For example
>> this function:
> ...
>
> Don't you just want something very roughly like:
>
> int pinctrl_pm_select_xxx_state(struct device *dev,
>                 unsigned long offset, char *name)
> {
>         struct dev_pin_info *pins = dev->pins;
>         struct pinctrl_state **s = (void *)(((char *)pins) + offset)
(...)
>     return pinctrl_pm_select_xxx_state(dev,
>                 offsetof(struct dev_pin_info, default_state),
>                 "default");
> }

Argh that seems a bit too esoteric to save these few
lines, maybe it's me being too stupid to parse this
but it makes the code less maintainable for the pinctrl
maintainer atleast so will not happen right now.

But it is clever still. :-)

Yours,
Linus Walleij
