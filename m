Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbaD2BIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:08:55 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:38370 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbaD2BIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:08:54 -0400
MIME-Version: 1.0
X-Originating-IP: [209.133.115.210]
In-Reply-To: <1401022774.yKcHJAmPtb@wuerfel>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
	<1398265476-29373-6-git-send-email-maxime.ripard@free-electrons.com>
	<1401022774.yKcHJAmPtb@wuerfel>
Date: Mon, 28 Apr 2014 18:08:53 -0700
Message-ID: <CAOesGMhgTJugKyfa3QB=Zk1O0bDX9EgBnr4i9KeCD5bBpZ9mVw@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: sunxi: Remove sun4i and sun7i machine definitions
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-sunxi@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 9:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 23 April 2014 17:04:36 Maxime Ripard wrote:
>>
>> -static void __init sunxi_dt_init(void)
>> -{
>> -       of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>> -}
>> -
>> -static const char * const sunxi_board_dt_compat[] = {
>> -       "allwinner,sun4i-a10",
>> -       "allwinner,sun5i-a10s",
>> -       "allwinner,sun5i-a13",
>> -       NULL,
>> -};
>> -
>> -DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
>> -       .init_machine   = sunxi_dt_init,
>> -       .dt_compat      = sunxi_board_dt_compat,
>> -MACHINE_END
>> -
>>  static const char * const sun6i_board_dt_compat[] = {
>>         "allwinner,sun6i-a31",
>>         NULL,
>
> I'd like to hear more opinions on this. We could either rely
> on the generic code, or we could keep the entry with just
> the .dt_compat line and the name, so /proc/cpuinfo contains
> a meaningful platform name.
>
> Either approach works for me, but I think we should do this
> consistent across platforms. Olof, do you have an opinion?

In reality, today, most platforms still need some out-of-tree stuff
that usually goes into the mach directory on out of tree kernels. It
also gives a place to stick the Kconfig entries, it's been nice to
have them split out in per-platform Kconfigs instead of having them
all modify and conflict the shared one.

I know those aren't strong arguments to keep it, but given that all
other things are more or less equal, it's a good a reason as any.

But, I'm not picky either way.


-Olof
