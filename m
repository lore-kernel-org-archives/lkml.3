Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaFQHKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:10:45 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49068 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaFQHKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:10:44 -0400
Date: Tue, 17 Jun 2014 08:10:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>, arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        gabriel.fernandez@st.com, daniel.thompson@linaro.org,
        Maxime Coquelin <maxime.coquelin@st.com>
Subject: Re: [PATCH V2] ARM: STi: DT: Properly define sti-ethclk & stmmaceth
 for stih415/6
Message-ID: <20140617071037.GA4139@lee--X1>
References: <1402345355-5682-1-git-send-email-peter.griffin@linaro.org>
 <20140616092339.GB27978@griffinp-ThinkPad-X1-Carbon-2nd>
 <539ED4C5.4070906@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <539ED4C5.4070906@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/16/2014 11:23 AM, Peter Griffin wrote:
> >This patch fixes two problems: -
> >
> >1) The device tree isn't currently providing sti-ethclk which is
> >required by the dwmac glue code to correctly configure the ethernet
> >PHY clock speed.
> >
> >This means depending on what the bootloader/jtag has
> >configured this clock to, and what switch/hub the board is plugged
> >into you most likely will NOT successfully negotiate a ethernet link.
> >
> >2) The stmmaceth clock was associated with the wrong clock. It was
> >referencing the PHY clock rather than the interconnect clock which
> >clocks the IP.
> >
> >This patch also brings us closer to not having to boot the upstream
> >kernel with the clk_ignore_unused parameter.
> >
> >Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> >---
> >  arch/arm/boot/dts/stih415.dtsi           | 8 ++++----
> >  arch/arm/boot/dts/stih416.dtsi           | 8 ++++----
> >  include/dt-bindings/clock/stih415-clks.h | 1 +
> >  include/dt-bindings/clock/stih416-clks.h | 1 +
> >  4 files changed, 10 insertions(+), 8 deletions(-)
> 
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
> 
> Thanks for the fix!

Can you apply Maxime and my Acks and send to ARM-SoC (CC'ed), due for
their -fixes branch please?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
