Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3FDQKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:10:12 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51856 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab3FDQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:10:07 -0400
MIME-Version: 1.0
In-Reply-To: <1394174.ONngHnHYKL@wuerfel>
References: <1369741403-25315-2-git-send-email-alexandre.belloni@free-electrons.com>
 <6466898.RnYOe3jpGG@wuerfel> <CAGVrzcbRS3x5fgD1BfOk4-oTUsAY9FA2V621OvZLJQNZ01brCg@mail.gmail.com>
 <1394174.ONngHnHYKL@wuerfel>
From: Florian Fainelli <florian@openwrt.org>
Date: Tue, 4 Jun 2013 17:09:26 +0100
X-Google-Sender-Auth: CDbAFGVY9fti3X3TNrwz3RSN15Y
Message-ID: <CAGVrzcZcVB5+NqLop+ALrX4Jx_SyNatczLt4oNzXr7bjgKMXhg@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] net: phy: prevent linking breakage
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "alexandre.belloni" <alexandre.belloni@free-electrons.com>,
        kernel <kernel@pengutronix.de>, "shawn.guo" <shawn.guo@linaro.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/4 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday 04 June 2013 16:36:50 Florian Fainelli wrote:
>> It seems to me that what David proposes is to have say an
>> arch/arm/mach-foo/phy-fixups.c file which is only enabled when
>> CONFIG_PHYLIB is set (obj-$(CONFIG_PHYLIB) += phy-fixup.o), such that
>> it does not need to have any conditionnals when calling
>> phy_register_fixup. This sounds a little unusual, but why not.
>
> I don't think it would actually help us, because then we still need
> to declare a local function that gets called from the board init
> code. Instead of doing
>
>         if (IS_ENABLED(CONFIG_PHYLIB))
>                  phy_register_fixup_for_uid(phy_id, foo_phy_fixup);
>
> we would then do
>
>         if (IS_ENABLED(CONFIG_PHYLIB))
>                 foo_phy_fixup_register();
>
> which is not much different at all.

You would just need to define a stub for your arch_foo_phy_fixup()
which has a different definition depending on whether CONFIG_PHYLIB is
defined or not.

This would be just one function, instead of the whole bunch of stubs
needed for phylib. Right now its probably 1 vs 3, so it does not make
that much of a difference but who knows, if we had more phylib stubs
and forget to update the stubs? (which tends to happen pretty often).

The size savings are exactly the same in both approaches anyway.
--
Florian
