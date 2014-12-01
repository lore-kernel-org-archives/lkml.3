Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaLAQHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:07:16 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35419 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaLAQHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <1416834177-11170-1-git-send-email-gautam.vivek@samsung.com>
References: <CAFp+6iF-N63YSsdv2a6=MYp_mD=eQY_Oi8=9JVNU5dG0BA7YGQ@mail.gmail.com>
	<1416834177-11170-1-git-send-email-gautam.vivek@samsung.com>
Date: Tue, 2 Dec 2014 01:07:11 +0900
Message-ID: <CA+Ln22GHVinmpJccYYxNjYeApj3miy_zGMnWd8e5AOt0PCjh9g@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: exynos: Add BUS1 pin controller for exynos7
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Please see my comments below.

2014-11-24 22:02 GMT+09:00 Vivek Gautam <gautam.vivek@samsung.com>:
> USB and Power regulator on Exynos7 require gpios available
> in BUS1 pin controller block.
> So adding the BUS1 pinctrl support.
>
> Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>
> This patch was part of series:
> "[PATCH 00/11] Exynos7: Adding USB 3.0 support"
>  https://lkml.org/lkml/2014/11/21/247
>
> Changes since V1:
>  - Added support for all pin banks which are part of BUS1 pin controller.
>
>  drivers/pinctrl/samsung/pinctrl-exynos.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

I have missed this with previous patch, but DT bindings documentation
should list all aliases for all supported compatible strings, because
they are required for correct operation. There is a small section
about aliases in [1] already, so please add there information about
aliases for Exynos7 pin controllers along with their names, e.g.

Aliases for controllers compatible with "samsung,exynos7-pinctrl":
 - pinctrl0: pin controller of ALIVE block,
 - pinctrl1: pin controller of BUS0 block,
 [...]
 - pinctrl8: pin controller of BUS1 block.

[1] Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt

I guess you can do this in separate patch or respin this one with this added.

Best regards,
Tomasz
