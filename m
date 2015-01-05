Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbbAEOFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:05:49 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:50587 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbbAEOFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <1417777254-26579-3-git-send-email-k.kozlowski@samsung.com>
References: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
	<1417777254-26579-3-git-send-email-k.kozlowski@samsung.com>
Date: Mon, 5 Jan 2015 15:05:46 +0100
Message-ID: <CACRpkdaVJKmMzc0uNL1XK8w93Cf_yWcdW9w4E2NFxroWEkkzZg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] pinctrl: exynos: Fix GPIO setup failure because
 domain clock being gated
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 12:00 PM, Krzysztof Kozlowski
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
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Tomasz, is this OK and should I apply it for fixes or next?

Yours,
Linus Walleij
