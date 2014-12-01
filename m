Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaLAIhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:37:31 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12078 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaLAIh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:37:29 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-03-547c28c576a9
Content-transfer-encoding: 8BIT
Message-id: <1417423043.4055.14.camel@AMDC1943>
Subject: Re: [PATCH v2 3/5] pinctrl: exynos: Fix GPIO setup failure because
 domain clock being gated
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
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
Date: Mon, 01 Dec 2014 09:37:23 +0100
In-reply-to: <CA+Ln22Ejo51VPWf6DmuRvV_fZr_H=-BXAshSPSOokNE1bz=-QA@mail.gmail.com>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
 <1417011857-10419-4-git-send-email-k.kozlowski@samsung.com>
 <CACRpkdb8F8YcvFeHPvOKHjx_p4HEpimck3XRabB3oHpZTdmRQQ@mail.gmail.com>
 <1417183724.18249.36.camel@AMDC1943>
 <CA+Ln22Ejo51VPWf6DmuRvV_fZr_H=-BXAshSPSOokNE1bz=-QA@mail.gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xy7pHNWpCDHZsFLXYOGM9q8X8I+dY
	LdquHGS3OPq7wKL/8Wtmi6ebHzNZnG16w24x5c9yJotNj6+xWmye/4fR4vKuOWwWM87vY7K4
	fZnXYu2Ru+wWTydcZLM4/Kad1eLYjCWMFqt2/WF0EPJoae5h8/j7/DqLx85Zd9k9Nq3qZPO4
	c20Pm8fmJfUefVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlbFscx9jwTaRikfr17M0MC4X6GLk
	5JAQMJF4/34GI4QtJnHh3nq2LkYuDiGBpYwSJxe9ZQZJ8AoISvyYfI+li5GDg1lAXuLIpWyQ
	MLOAusSkeYuYIeo/M0rs+vuUCaJeX+Jfz2kwW1ggTWLb9FlgC9gEjCU2L1/CBmKLADV/m9LP
	DtLMLPCATeL2iw2sIAkWAVWJ32uvgzVwCgRLPLvyFiwuJLCLSeLCYrAjJASUJRr73SYwCsxC
	ct4shPNmITlvASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQSPu6g3HpMatDjAIcjEo8
	vJprq0OEWBPLiitzDzFKcDArifD+egEU4k1JrKxKLcqPLyrNSS0+xMjEwSkFDMc0HcFpSbMP
	WShvODDjTm929trZ3CaBkof3zz/1y2Vi7T6H1I/P06b5T2g5/YH18WdZocbm/f+O9L0pEmHr
	1GQQ+18UlrMhjK13zqPXk1w+PivXMKw2yLZY7Vc9+fGvK8cNlq7VbapYY9m/UOt4zvTsnukT
	wtdo1CfNu68c//jsU0X93RPWvVFiKc5INNRiLipOBABy8biXkgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On nie, 2014-11-30 at 21:19 +0900, Tomasz Figa wrote:
> Hi Krzysztof,
> 
> 2014-11-28 23:08 GMT+09:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> > On pią, 2014-11-28 at 15:04 +0100, Linus Walleij wrote:
> >> On Wed, Nov 26, 2014 at 3:24 PM, Krzysztof Kozlowski
> >> <k.kozlowski@samsung.com> wrote:
> >>
> >> > The audio subsystem on Exynos 5420 has separate clocks and GPIO. To
> >> > operate properly on GPIOs the main block clock 'mau_epll' must be
> >> > enabled.
> >> >
> >> > This was observed on Peach Pi/Pit and Arndale Octa (after enabling i2s0)
> >> > after introducing runtime PM to pl330 DMA driver. After that commit the
> >> > 'mau_epll' was gated, because the "amba" clock was disabled and there
> >> > were no more users of mau_epll.
> >> >
> >> > The system hang just before probing i2s0 because
> >> > samsung_pinmux_setup() tried to access memory from audss block which was
> >> > gated.
> >> >
> >> > Add a clock property to the pinctrl driver and enable the clock during
> >> > GPIO setup. During normal GPIO operations (set, get, set_direction) the
> >> > clock is not enabled.
> 
> Could you make sure that possibility of gating this clock is worth the
> effort of adding gating code to all affected drivers? If there is no
> significant change in power consumption maybe it could be simply keep
> running all the time?

I had an impression that last time you disliked such idea:
http://www.spinics.net/lists/arm-kernel/msg338127.html
That's why I developed these patches. Because keeping a clock always on,
even when it is unused, is undesirable.

Anyway, I did some simple measurements (after booting Arndale Octa
to /bin/sh, idle):
 - with mau_epll gated: ~523 mA
 - with mau_epll always on: ~531 mA

Keeping it on increases energy usage by 1.5% in idle (with measurement
uncertainty ~0.4%).


> Also isn't a similar problem happening due to power domains? I believe
> the whole maudio block is located in a separate power domain but
> somehow it doesn't get turned off?

There is Maudio power domain... but I think it is not related here.
Pinctrl driver does not have runtime PM and is not attached to a domain.
I thought about other solution to this problem (with utilization of
power domains):
 - add runtime PM to pinctrl and audss clocks,
 - attach pinctrl and audss clocks to maudio power domain,
 - enable the clock when power domain is turned on.
However almost the same changes had to be added to pinctrl and audss
clocks drivers (replace clock_enable() with pm_runtime_get_sync()).

Best regards,
Krzysztof


