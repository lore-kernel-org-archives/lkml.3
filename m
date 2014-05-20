Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaETNpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:45:08 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51851 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaETNpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:45:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com, galak@codeaurora.org,
        grant.likely@linaro.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        grygorii.strashko@ti.com, olof@lixom.net, w-kwok2@ti.com,
        sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v3 0/5] Introduce keystone reset driver
Date: Tue, 20 May 2014 15:44:15 +0200
Message-ID: <5272855.vIyLIadgKe@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537B5598.8070603@ti.com>
References: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com> <5095812.b6DgWAxYzH@wuerfel> <537B5598.8070603@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mGfXc7uR6mCed4dfYfN2pIJ9fsy9l7ZJasXAOSlg8u7
 dFBt9QRkW3lPNAF3up8ghWbjBVzg3tzAA2krpqHv37H2qwlSk8
 ELp9/cdWskDujaw+QTu/d2RqREyuplyr9sPavjrfY7IT7zTKnR
 I2aHmZ7hulMuYfHDX0B/TRdRPhgel30blJ96jBAqdf+BwW6S8T
 AhP03TEiEcr6L4Sbrc7yaJucksth50IYFgNZkTx1XogoznSDIG
 zUhJ9tIviq3V+X4fXbOY6IGLCP7RhVNGn9hug1BEccnxLTW8v6
 S/N7PMbIMZRMbmamhvBmZyST0MkyCeYTkvBe3WlMkfdsO39AvX
 QIdY56BlN58+clKCLaVc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 16:16:08 Ivan Khoronzhuk wrote:
> Thank for the reply
> 
> The reset driver uses two ranges:
> - RSTYPE, RSTCTRL,RSTCFG, RSISO  (Reset Main PLL Controller)
> - RESETMUX8-10 registers
> 
> The content of these register ranges are completely used by the reset 
> driver.
> Currently no one on the SoC can access them instead of the reset driver.
> Also we don't use syscon/regmap at all - so adding this will be some 
> overhead.
> 
> As I posted previously:
> "...configuring Reset multiplexer & PLL. And it tunes not only watchdog 
> usage..."
> 
> Yes, it tunes not only watchdog usage and uses part of registers from 
> PLL controller,
> but all it works with are connected with reset functionality. These 
> ranges are used only
> by reset driver and their purpose is reset functionality.
> 
> Maybe in the future some soft can use ranges in question for own tasks, 
> but it should be
> done via reset driver. So as I see there is no reasons to use regmap for 
> reset driver.

You should not look at these registers in isolation, they are part of
some register area that has other functions as well and that you should
at least represent correctly in DT.

When I see something like

+                       reg = <0x23100e4 0x10>,
+                             <0x2620328 0x10>;

I am certain that there are other things between 0x2310000 and 0x23100e3, and
probably after 0x23100f4 as well. There must be some data sheet that
gives this register range a proper name, so put that into DT rather than
making up some arbitrary stuff that happens to match how today's kernel
driver needs it.

	Arnd
