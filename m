Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaJWAEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 20:04:12 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:40773 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaJWAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 20:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <1413933981-25875-1-git-send-email-zyw@rock-chips.com>
References: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
	<1413933981-25875-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 22 Oct 2014 17:04:08 -0700
X-Google-Sender-Auth: 9F_a9U-1CSiK0jLDOLUpUfJcq7A
Message-ID: <CAD=FV=VAxmju6L6AEkU4VSuAEKDGmoN6rxE17JsTttWPHKKvBA@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] ARM: dts: add RK3288 suspend support
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Xie <xxx@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Oct 21, 2014 at 4:26 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> add pmu_intmem node for suspend, add global_pwroff pinctrl.
> The pmu_intmem is used to store the resume code.
> global_pwroff is held low level at work, it would be pull to high
> when entering suspend. PMICs can get this signal, then shut down
> some power rails. So please reference the global_pwroff pinctrl
> as part of the PMIC config.

nit: I would just say to reference this in the board DTS file since
some boards need it.  You could imagine this being useful to something
other than a PMIC.


> +       pmu_intmem@ff720000 {
> +               compatible = "rockchip,rk3288-pmu-sram", "mmio-sram";
> +               reg = <0xff720000 0x4000>;

My TRM says this is 4K big.  You're specifying 16K here.  If it's
really 4K, it should be <0xff720000 0x1000>
