Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaLDKwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:52:49 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64458 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaLDKwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:52:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-8e-54803cfc941b
Message-id: <1417690363.3314.7.camel@AMDC1943>
Subject: Re: [PATCH v3 0/3] Fix Arndale Octa/Peach Pi boot on Audio subsystem
 clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 04 Dec 2014 11:52:43 +0100
In-reply-to: <1417690075-13483-1-git-send-email-k.kozlowski@samsung.com>
References: <1417690075-13483-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xq7p/bBpCDA4t0LTYOGM9q8X8I+dY
	LdquHGS3OPq7wKL/8Wtmi6ebHzNZnG16w24x5c9yJotNj6+xWmye/4fR4vKuOWwWM87vY7JY
	e+Quu8XTCRfZLA6/aWe1WLXrD6ODgMff59dZPHbOusvusWlVJ5vHnWt72Dw2L6n36NuyitHj
	8ya5APYoLpuU1JzMstQifbsErowPTc1MBWeEKpZ8e8zWwHiGr4uRk0NCwERiw55L7BC2mMSF
	e+vZuhi5OIQEljJK7Nx8jQnC+cwosXnjNzaQKl4BPYlVf6exgNjCAmESx152gnWzCRhLbF6+
	BKxGRCBS4vzLW4wgzcwCW1kkpjVsZQRJsAioSrStPcsKYnMKeEj8+3URbJCQgLvEt2V7wJqZ
	BdQlJs1bxNzFyAF0krJEY78bxF5BiR+T77FAlMhLbF7zlnkCo8AsJB2zkJTNQlK2gJF5FaNo
	amlyQXFSeq6hXnFibnFpXrpecn7uJkZIRH3Zwbj4mNUhRgEORiUe3gVP60OEWBPLiitzDzFK
	cDArifCesm4IEeJNSaysSi3Kjy8qzUktPsTIxMEp1cCov9rF9Jzqx/hP/Jy7PkclVc3jMvPp
	MrhwTvPl9KdKzPdWHii7n3l6l4udYhzT/RsxC9cFzg6bs0vsq1L3m71laVGH1s4JnG9yO/54
	0TwTqeTLy5I5D8bWtL5wL1ucOjGby4qzia9BqSz7jtS5NPYkc9/PDYG7whua+lf+Mn7+91Rw
	zSX+bZeUWIozEg21mIuKEwHJVfZChgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-12-04 at 11:47 +0100, Krzysztof Kozlowski wrote:
> Hi,
> 
> 
> Changes since v2
> ================
> 1. Patch 1 applied ("clk: samsung: Fix double add of syscore ops after
>    driver rebind"), remove it.
> 2. Squash patch 5 with "clk: samsung: Fix clock disable
>    failure because domain being gated". Suggested by Sylwester.
> 3. Patch 1/3: Fix issues pointed by Sylwester.
> 4. Patch 2/3: Fix redundant clk_disable when removing driver (clk is
>    already disabled). Add missing check !=null when removing driver.
> 5. Patch 3/3: Extend commit message.


Aaa, I forgot to add tested-by Javier Martinez Canillas
<javier.martinez@collabora.co.uk>
https://lkml.org/lkml/2014/11/26/420

These are minor changes so I think the "tested-by" still applies.
If patches are OK and someone applies the, please don't forget about
that tag.

Best regards,
Krzysztof

> 
> Changes since v1
> ================
> 1. clocks-audss: Reimplement own clock register functions instead
>    changing clk API. Minor fixes. (after idea from Tomasz Figa)
> 2. Add new patches: fix for pinctrl and minor fixes in clk-audss.
> 
> Description
> ===========
> This patchset tries to solve dependency between AudioSS components
> (clocks and GPIO) and main clock controller on Exynos 5420 platform.
> 
> This solves boot failure of Peach Pi/Pit and Arndale Octa [1].
> 
> Any access to memory of audss block (like checking if clock is enabled
> or configuring GPIO) will hang if main audss clock is gated.
> 
> Tested on Arndale Octa board.
> 
> [1] http://www.spinics.net/lists/linux-samsung-soc/msg39331.html
> 
> Best regards,
> Krzysztof Kozlowski
> 
> 
> Krzysztof Kozlowski (3):
>   clk: samsung: Fix clock disable failure because domain being gated
>   pinctrl: exynos: Fix GPIO setup failure because domain clock being
>     gated
>   ARM: dts: exynos5420: Add clock for audss pinctrl (fixing GPIO setup
>     failure)
> 
>  .../bindings/pinctrl/samsung-pinctrl.txt           |   6 +
>  arch/arm/boot/dts/exynos5420-pinctrl.dtsi          |   3 +
>  drivers/clk/samsung/clk-exynos-audss.c             | 357 ++++++++++++++++++---
>  drivers/pinctrl/samsung/pinctrl-samsung.c          | 111 ++++++-
>  drivers/pinctrl/samsung/pinctrl-samsung.h          |   2 +
>  5 files changed, 436 insertions(+), 43 deletions(-)
> 

