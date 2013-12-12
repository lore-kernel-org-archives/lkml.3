Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3LLSP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:15:59 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61479 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LLSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:15:58 -0500
MIME-Version: 1.0
In-Reply-To: <1386585509-12495-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1386585509-12495-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Thu, 12 Dec 2013 19:15:57 +0100
Message-ID: <CACRpkdbjo-E2=V3yyxJ2ofwhj_JPT0=txy9JtS0yb2RWSK51ZA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinconf: remove checks on ops->pin_config_get
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 11:38 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:

> ops->pin_config_get() is only used in one specific path that will only be taken
> for generic pinconf drivers (ops->is_generic == true) when dumping the pinconf
> by using debugfs.
>
> By removing the check in pinconf_check_ops(), let's stop pressuring people to
> write a pin_config_get() function that will never be used and so will probably
> never be tested.
>
> Removing the check in pinconf_pins_show() allows driver to not implement
> pin_config_get() but still get a dump of the pinconf in debugfs by implementing
> pin_config_dbg_show().
>
> Finally, not implementing pin_config_get() now results in returning -ENOTSUPP
> instead of -EINVAL. While this doesn't have any real impact for now, this feels
> more right.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Yeah hm, OK patch applied.

For non-generic pinconf drivers this is more helpful.

Getting pin config or pin multiplexing from the hardware is
somewhat unimplemented in many drivers, that is one of the
holes we need to work on...

Yours,
Linus Walleij
