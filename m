Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaJRA5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 20:57:23 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41168 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaJRA5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 20:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <1413578830-26220-1-git-send-email-zyw@rock-chips.com>
References: <1413578696-26125-1-git-send-email-zyw@rock-chips.com>
	<1413578830-26220-1-git-send-email-zyw@rock-chips.com>
Date: Fri, 17 Oct 2014 17:57:20 -0700
X-Google-Sender-Auth: bt4ZluzQf_T_-u-UcfFvmRqKfGQ
Message-ID: <CAD=FV=W__U7+YQkxQmt1BRkuNvfqMmdTJe-cT3iy6i7uCbaK=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ARM: rockchip: add suspend and resume for RK3288
From: Doug Anderson <dianders@chromium.org>
To: Chris <zyw@rock-chips.com>
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
        Tony Xie <xxx@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Fri, Oct 17, 2014 at 1:47 PM,  <zyw@rock-chips.com> wrote:
> From: Chris Zhong <zyw@rock-chips.com>
>
> It's a basic version of suspend and resume for rockchip, it only support RK3288
> now.
>
> Signed-off-by: Tony Xie <xxx@rock-chips.com>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v2:
> - add the regulator calls in prepare and finish.
> - add the pinmux of gpio6_c6 save and restore

I'm a bit out of time to do a real review right now, but I would have
expected that the pinmux stuff:

* was saved and restored in the pinmux driver.

* was in a separate patch, before this one in the series.


The pinmux driver should have callbacks for saving and restoring
pinmux state, so you should use those.  Maybe exynos_pinctrl_suspend()
is an example, though you only need to save one pin.  You should
probably also explain that only gpio6_c6 needs to be saved and
restored since the MaskROM clobbers it upon resume.

-Doug
