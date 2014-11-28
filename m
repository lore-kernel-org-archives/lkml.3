Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaK1OEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:04:53 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:32831 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaK1OEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:04:50 -0500
MIME-Version: 1.0
In-Reply-To: <1417011857-10419-4-git-send-email-k.kozlowski@samsung.com>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
	<1417011857-10419-4-git-send-email-k.kozlowski@samsung.com>
Date: Fri, 28 Nov 2014 15:04:49 +0100
Message-ID: <CACRpkdb8F8YcvFeHPvOKHjx_p4HEpimck3XRabB3oHpZTdmRQQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] pinctrl: exynos: Fix GPIO setup failure because
 domain clock being gated
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 3:24 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:

> The audio subsystem on Exynos 5420 has separate clocks and GPIO. To
> operate properly on GPIOs the main block clock 'mau_epll' must be
> enabled.
>
> This was observed on Peach Pi/Pit and Arndale Octa (after enabling i2s0)
> after introducing runtime PM to pl330 DMA driver. After that commit the
> 'mau_epll' was gated, because the "amba" clock was disabled and there
> were no more users of mau_epll.
>
> The system hang just before probing i2s0 because
> samsung_pinmux_setup() tried to access memory from audss block which was
> gated.
>
> Add a clock property to the pinctrl driver and enable the clock during
> GPIO setup. During normal GPIO operations (set, get, set_direction) the
> clock is not enabled.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Waiting for Tomasz to review this.

Can this patch be applied in separation from the others?

Yours,
Linus Walleij
