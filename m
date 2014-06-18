Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaFRQRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:17:23 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49432 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaFRQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:17:21 -0400
MIME-Version: 1.0
Date: Wed, 18 Jun 2014 17:17:19 +0100
Message-ID: <CAD8Lp46pFGWSA6c1r-xGUbNDkcACyZZkru+m7+xH+BQRr7ULPg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add support for Exynos clock output configuration
From: Daniel Drake <drake@endlessm.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Tue, May 20, 2014 at 5:43 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Since the block responsible for handling the pin is PMU, not CMU,
> a separate driver, that binds to PMU node is required and acquires
> all input clocks by standard DT clock look-up. This way we don't need
> any cross-IP block drivers and cross-driver register sharing or
> nodes for fake devices.
>
> To represent the PMU mux/gate clock, generic composite clock is registered.
>
> Tested on Odroid U3, with HSIC/USB hub using CLKOUT as reference clock,
> with some additional patches.
>
> Depends on:
> [PATCHv5 0/4] Enable usbphy and hsotg for exynos4
> (No link, sorry, I could not find it in any archive yet...)
> for Exynos4210/4x12 PMU binding and DT nodes.

This isn't working for me.
Testing linus master e99cfa2d0634881b8a41d56c48b5956b9a3ba162 plus:
    ARM: dts: exynos4: add port sub-nodes to exynos usb host modules
    ARM: dts: exynos4412-odroidx: enable common hardware blocks
    ARM: dts: exynos4412-odroidx: add support for USB (phy, host, device)
    ARM: dts: refactor Odroid DTS file and add support for Odroid X2 and U2/U3

Testing on ODROID-U2.

I apply the first patch here (clk: samsung: exynos4: Add missing
CPU/DMC clock hierarchy) and things continue to work. Now when I add
the second patch "clk: samsung: exynos4: Add CLKOUT clock hierarchy"
boot hangs at:

[    4.753740] s3c-rtc 10070000.rtc: setting system clock to
2000-01-01 02:43:30 UTC (946694610)
[    4.753809] ### dt-test ### No testcase data in device tree; not
running tests
[    4.791155] gps-power-domain: Power-off latency e

Any ideas?
Thanks
Daniel
