Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966824AbaFTKdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:33:40 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48589 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbaFTKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:33:36 -0400
Message-ID: <53A40DE9.4030100@gmail.com>
Date: Fri, 20 Jun 2014 12:33:13 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Drake <drake@endlessm.com>, Tomasz Figa <t.figa@samsung.com>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add support for Exynos clock output configuration
References: <CAD8Lp46pFGWSA6c1r-xGUbNDkcACyZZkru+m7+xH+BQRr7ULPg@mail.gmail.com>
In-Reply-To: <CAD8Lp46pFGWSA6c1r-xGUbNDkcACyZZkru+m7+xH+BQRr7ULPg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 18.06.2014 18:17, Daniel Drake wrote:
> Hi Tomasz,
> 
> On Tue, May 20, 2014 at 5:43 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>> Since the block responsible for handling the pin is PMU, not CMU,
>> a separate driver, that binds to PMU node is required and acquires
>> all input clocks by standard DT clock look-up. This way we don't need
>> any cross-IP block drivers and cross-driver register sharing or
>> nodes for fake devices.
>>
>> To represent the PMU mux/gate clock, generic composite clock is registered.
>>
>> Tested on Odroid U3, with HSIC/USB hub using CLKOUT as reference clock,
>> with some additional patches.
>>
>> Depends on:
>> [PATCHv5 0/4] Enable usbphy and hsotg for exynos4
>> (No link, sorry, I could not find it in any archive yet...)
>> for Exynos4210/4x12 PMU binding and DT nodes.
> 
> This isn't working for me.
> Testing linus master e99cfa2d0634881b8a41d56c48b5956b9a3ba162 plus:
>     ARM: dts: exynos4: add port sub-nodes to exynos usb host modules
>     ARM: dts: exynos4412-odroidx: enable common hardware blocks
>     ARM: dts: exynos4412-odroidx: add support for USB (phy, host, device)
>     ARM: dts: refactor Odroid DTS file and add support for Odroid X2 and U2/U3
> 
> Testing on ODROID-U2.
> 
> I apply the first patch here (clk: samsung: exynos4: Add missing
> CPU/DMC clock hierarchy) and things continue to work. Now when I add
> the second patch "clk: samsung: exynos4: Add CLKOUT clock hierarchy"
> boot hangs at:
> 
> [    4.753740] s3c-rtc 10070000.rtc: setting system clock to
> 2000-01-01 02:43:30 UTC (946694610)
> [    4.753809] ### dt-test ### No testcase data in device tree; not
> running tests
> [    4.791155] gps-power-domain: Power-off latency e
> 
> Any ideas?

Thanks for testing.

It's most likely an issue with ISP power domain. Certain clock
controller registers are located there and there is no proper handling
of this in the clock driver yet. You can test things by skipping patch 3
and this should give you a working clkout, just limited to clocks not
going through clkout hierarchies of clock domains, e.g. xxti and xusbxti.

I'm aware of the problem and will fix it in next version.

Best regards,
Tomasz
