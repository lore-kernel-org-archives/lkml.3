Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaF0HXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:23:51 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50855 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaF0HXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:23:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Feng Kan <fkan@apm.com>
Cc: Chen-Yu Tsai <wens@csie.org>, dbaryshkov <dbaryshkov@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>, dwmw2 <dwmw2@infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, patches <patches@apm.com>
Subject: Re: [PATCH V7 1/6] power: reset: Add generic SYSCON register mapped reset
Date: Fri, 27 Jun 2014 09:23:32 +0200
Message-ID: <12435553.7pqAlNHzh1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL85gmCOzaT+dJf9e8Uj-w3v1nq8Qjg-EXfWDN5kdrU2k=kHJQ@mail.gmail.com>
References: <1403737406-6474-1-git-send-email-fkan@apm.com> <CAGb2v65mGXDGb8Y045kehKufpMZWnfBm4dBJarJeOa8j-3g0RQ@mail.gmail.com> <CAL85gmCOzaT+dJf9e8Uj-w3v1nq8Qjg-EXfWDN5kdrU2k=kHJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4CzPILJiY3VYh+P1/mfbNfcnrb0TPgu4wcE0D7zTf48
 hwAp8GwyTn/4tAne0UbucUy/nY1PU4PmacDLgGhqakeLqkJvZt
 ZQtcX22F0ilUrfKEkc2WDgm20ppAdy4FT8Q0p6eCg+TVtHptii
 3m32gB1OVlZqk/x/0mWLZqS1wamjxplMdYrX2JrCYTTXKAP60G
 ZahYZAmvVbA8gwTTaOQHaQH8KTHq0ZEjzRqJdUcY7923P1qoFj
 rJh23K3kocEL//RZhjRJlHINMlQKTcXmLRKlMdshfnkEbuik8W
 Y6w8mJyz6URRtQvLsy3QfgFQcWYv6zNpqR/e81Qs/7DbNUExO3
 DgQBuQ3Q4qlhtFFPpFaU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2014 09:51:14 Feng Kan wrote:
> >> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> >> index bdcf517..7035236 100644
> >> --- a/drivers/power/reset/Kconfig
> >> +++ b/drivers/power/reset/Kconfig
> >> @@ -80,3 +80,9 @@ config POWER_RESET_KEYSTONE
> >>         help
> >>           Reboot support for the KEYSTONE SoCs.
> >>
> >> +config POWER_RESET_SYSCON
> >> +       bool "Generic SYSCON regmap reset driver"
> >> +       depends on ARCH_XGENE
> >
> > If this is supposed to be generic, why are you depending on
> > a certain platform?
> 
> Yes, the problem was that it was breaking the x86 build.

You probably need to list the exact dependencies then, at least make
it depend on MFD_SYSCON and OF. We generally want all drivers to
build without warnings on all architectures. You can limit it to
(ARM || ARM64 || COMPILE_TEST) if you don't want it to show up on
x86 by default, but it should still be possible to build it when
COMPILE_TEST is set.

	Arnd
