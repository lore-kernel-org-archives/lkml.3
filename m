Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaK3MTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:19:47 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64700 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK3MTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:19:45 -0500
MIME-Version: 1.0
In-Reply-To: <1417183724.18249.36.camel@AMDC1943>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
	<1417011857-10419-4-git-send-email-k.kozlowski@samsung.com>
	<CACRpkdb8F8YcvFeHPvOKHjx_p4HEpimck3XRabB3oHpZTdmRQQ@mail.gmail.com>
	<1417183724.18249.36.camel@AMDC1943>
Date: Sun, 30 Nov 2014 21:19:44 +0900
Message-ID: <CA+Ln22Ejo51VPWf6DmuRvV_fZr_H=-BXAshSPSOokNE1bz=-QA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] pinctrl: exynos: Fix GPIO setup failure because
 domain clock being gated
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

2014-11-28 23:08 GMT+09:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> On pią, 2014-11-28 at 15:04 +0100, Linus Walleij wrote:
>> On Wed, Nov 26, 2014 at 3:24 PM, Krzysztof Kozlowski
>> <k.kozlowski@samsung.com> wrote:
>>
>> > The audio subsystem on Exynos 5420 has separate clocks and GPIO. To
>> > operate properly on GPIOs the main block clock 'mau_epll' must be
>> > enabled.
>> >
>> > This was observed on Peach Pi/Pit and Arndale Octa (after enabling i2s0)
>> > after introducing runtime PM to pl330 DMA driver. After that commit the
>> > 'mau_epll' was gated, because the "amba" clock was disabled and there
>> > were no more users of mau_epll.
>> >
>> > The system hang just before probing i2s0 because
>> > samsung_pinmux_setup() tried to access memory from audss block which was
>> > gated.
>> >
>> > Add a clock property to the pinctrl driver and enable the clock during
>> > GPIO setup. During normal GPIO operations (set, get, set_direction) the
>> > clock is not enabled.

Could you make sure that possibility of gating this clock is worth the
effort of adding gating code to all affected drivers? If there is no
significant change in power consumption maybe it could be simply keep
running all the time?

Also isn't a similar problem happening due to power domains? I believe
the whole maudio block is located in a separate power domain but
somehow it doesn't get turned off?

Could you investigate the above, please?

Best regards,
Tomasz
