Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3E2Fbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:31:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50309 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3E2Fbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:31:42 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <51A57D39.8030506@linaro.org>
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org>
	<87sj1qzaov.fsf@linaro.org>
	<5191AA89.6010901@linaro.org>
	<20130528231740.GA28879@quad.lixom.net>
	<51A57D39.8030506@linaro.org>
Date: Tue, 28 May 2013 22:31:41 -0700
Message-ID: <CAOesGMh50Dzr_jczHZC5_txfW=6a+7EgFKvgZgj9MhUcVUTJ1Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen board
From: Olof Johansson <olof@lixom.net>
To: Tushar Behera <tushar.behera@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 8:59 PM, Tushar Behera <tushar.behera@linaro.org> wrote:

> The patches are at [1].

FWIW, a cgit/gitweb link is easier to follow when you're reading an
email. Anyway, found the patches.

> There are a total of 6 patches on top of
> v3.10-rc3. 3 of them (a, b, d) are queued for 3.10-rc4 and another patch
> (c) is just a defconfig hack to get Arndale booting. Remaining 2 patches
> (e, f) are required to reset the hub during EHCI initialization.

Huh, I thought you said that (c) wasn't needed when I posted the
defconfig update. It'd be nice to see the code fixed to handle this
case instead of Linaro carrying a patch like this though. I.e. make it
able to deselect the uart, or make it tied to DEBUG_LL like on other
platforms instead of having a separate config for this.

> a. ARM: exynos: defconfig update
> b. ARM: EXYNOS: Update defconfig for Arndale and Origen board
> c. [TEMP] ARM: EXYNOS: Set low-level UART port to 2
> d. ARM: dts: Enabling samsung-usb2phy driver for exynos5250
> e. usb: ehci-s5p: add the HSIC port initialization
> f. ARM: dts: Add USB gpio entries for Arndale board
>
> I am not sure whether such kind of board-specific patches (e, f) are
> appreciated in the drivers. But that is all we need to get USB and
> Ethernet to work on v3.10-rc3 kernel.

I've come across a similar situation with wifi reset sequence on the
chromebook. On the product kernel we added some code to the board file
to deal with it, but if we keep doing that things will grow out of
hand.

I don't know if it'll be unpopular, but I think it's time to start a
drivers/platform/arm for these kind of things, and have those drivers
probe on the system compatible value, similar to how x86 does it (with
DMI tables). At least that's my plan for approaching the wifi
reset/power-on sequence on the Chromebook. I hope to have patches in
not all that long...

Likewise, the hub reset/enable code doesn't have to go with the USB
driver, right? I.e. if you cycle reset/enable on the hub after the
host and phy is configured, you'll still have a working setup?


-Olof
