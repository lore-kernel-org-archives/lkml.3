Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3FGHxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:53:38 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50149 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3FGHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <51AF73E9.90506@wwwdotorg.org>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
	<51AF73E9.90506@wwwdotorg.org>
Date: Fri, 7 Jun 2013 09:53:36 +0200
Message-ID: <CACRpkdZ4mO27NX0ccc7d_zmNoBQbvYZKOYm3NRH7f12HD9=NqA@mail.gmail.com>
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

On Wed, Jun 5, 2013 at 7:22 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>
>> +int pinctrl_pm_select_default_state(struct device *dev)
>
>> +int pinctrl_pm_select_sleep_state(struct device *dev)
>
>> +int pinctrl_pm_select_idle_state(struct device *dev)
>
> The implementation of those 3 functions is basically identical. I'd be
> inclined to move it to a helper function, and just pass (dev,
> pins->xxx_state) to it.

Point taken, but as the comments only affect pinctrl/core.c
and I got so many nice ACKs on the patch, I'll apply this
and think about a refactoring patch only hitting the core
in drivers/pinctrl/* to nice this up. (Need this infrastructure
in place for the OMAP work now I think...)

Yours,
Linus Walleij
