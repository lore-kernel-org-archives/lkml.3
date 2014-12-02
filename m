Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbaLBNee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:34:34 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34395 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaLBNec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:34:32 -0500
MIME-Version: 1.0
In-Reply-To: <25485084.A6ydfR9Xle@wuerfel>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org>
	<20141201225057.GA11285@n2100.arm.linux.org.uk>
	<CAD=FV=VT7gr504-ZgWPfha+40XDX5eShkzZ36bg=-4Oub1S27w@mail.gmail.com>
	<25485084.A6ydfR9Xle@wuerfel>
Date: Tue, 2 Dec 2014 14:34:32 +0100
Message-ID: <CACRpkdYd0=TBL3YFaZjn-dq1kH719SFSMG0aCRiRFbiTnxMxcQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        russ.dill@gmail.com, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 10:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 01 December 2014 15:04:59 Doug Anderson wrote:

>> Adding that code in assembly seems like a very, very bad idea.
>> Certainly my patch could wait until the DDR code is ready to be posted
>> upstream if that made sense.  One advantage of waiting is that it's
>> possible that the DDR code might end up moving elsewhere if it made
>> sense to have it part of a memory controller driver or something like
>> that.
(...)
> AFAICT, the quantenna implementation is similar to the itcm/dtcm
> stuff we already have (but are not using upstream), so I wonder
> why we can't use that here too, see Documentation/arm/tcm.txt

I agree. The TCM __tcm* macros to tag code and data for the TCM
can be used by any mechanism by modifying mem_init() in
arch/arm/mm/init.c

If the name is disturbing the __tcm* function can be renamed
__onchip* simply.

It will never work on multiplatform however, and if some real change
shall come to that, something like Russ Dills patches and a
generic approach to dynamic loading of onchip executables is
needed.

I had hopes of replacing the TCM mechanism with that
scheme, people also want to load onchip programs from
userspace as it happens, that would be the right way to go.

Yours,
Linus Walleij
