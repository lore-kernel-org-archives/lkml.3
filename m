Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbaCSIlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:41:07 -0400
Received: from 17.mo4.mail-out.ovh.net ([46.105.41.16]:57590 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756857AbaCSIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:41:03 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 04:41:03 EDT
MIME-Version: 1.0
In-Reply-To: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
Date: Wed, 19 Mar 2014 09:19:43 +0100
Message-ID: <CACh+v5N9Pxmuj_M4NLQQVLs-tuNYUAb8K1fdueWa+TcBxxt=Rw@mail.gmail.com>
Subject: Re: [PATCH 00/11] ARM: at91: rework main and slow clk implementation
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Boris BREZILLON <brezillonboris@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 5990631931051792525
X-Ovh-Remote: 209.85.192.172 (mail-pd0-f172.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,


2014-03-18 21:18 GMT+01:00 Boris BREZILLON <brezillonboris@gmail.com>:
>
> Hello,
>
> This series introduce the real clock model (as described in atmel datasheets)
> for slow and main clocks.
>
> The modifications introduced by this series break the DT compat, but, as the
> at91 CCF based implementation is pretty new (introduced in 3.14 only for sama5
> eval boards) I think it won't impact a lot of users.
>
> I tested it on sama5d3.
> Alexandre, Jean-Jacques, could you test this series on your eval boards
> (sam9261ek and sam9rlek) so that we can move to this new model and hopefully
> consider the at91 clk DT binding as (almost :-)) stable.
I'll try to do this this week, but I can make no promise
>
> Jean-Jacques, as you can see I reworked my first implementation as you
> suggested, do you want me to add your Signed-off-by in the next version ?
Nop, you did the job, not I.

>
> Mike, if this series is accepted, I'd like to get it merged as soon as possible
> to prevent other developpers from using a deprecated DT binding.
>
> Best Regards,
>
> Boris
>
> Boris BREZILLON (11):
>   clk: at91: rework main clk implementation
>   clk: at91: update main clk documentation
>   clk: at91: add slow clks driver
>   clk: at91: add slow clk documentation
>   ARM: at91/dt: move sama5d3 SoC to the new main/slow clk model
>   ARM: at91/dt: add xtal frequencies to sama5d3xcm boards
>   ARM: at91/dt: add xtal frequencies to sama5d3 xplained board
>   ARM: at91/dt: move at91sam9261 SoC to the new main clock model
>   ARM: at91/dt: define main xtal frequency of the at91sam9261ek board
>   ARM: at91/dt: move at91sam9rl SoC to the new slow/main clock models
>   ARM: at91/dt: define sam9rlek crystal frequencies
>
>  .../devicetree/bindings/clock/at91-clock.txt       |  128 ++++-
>  arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   10 +
>  arch/arm/boot/dts/at91sam9261.dtsi                 |   10 +-
>  arch/arm/boot/dts/at91sam9261ek.dts                |    4 +
>  arch/arm/boot/dts/at91sam9rl.dtsi                  |   45 +-
>  arch/arm/boot/dts/at91sam9rlek.dts                 |    8 +
>  arch/arm/boot/dts/sama5d3.dtsi                     |   61 +-
>  arch/arm/boot/dts/sama5d3xcm.dtsi                  |   10 +
>  drivers/clk/at91/Makefile                          |    4 +-
>  drivers/clk/at91/clk-main.c                        |  581 +++++++++++++++++---
>  drivers/clk/at91/clk-slow.c                        |  467 ++++++++++++++++
>  drivers/clk/at91/pmc.c                             |   12 +
>  drivers/clk/at91/pmc.h                             |    9 +
>  drivers/clk/at91/sckc.c                            |   57 ++
>  drivers/clk/at91/sckc.h                            |   22 +
>  include/linux/clk/at91_pmc.h                       |    1 +
>  16 files changed, 1342 insertions(+), 87 deletions(-)
>  create mode 100644 drivers/clk/at91/clk-slow.c
>  create mode 100644 drivers/clk/at91/sckc.c
>  create mode 100644 drivers/clk/at91/sckc.h
>
> --
> 1.7.9.5
>
