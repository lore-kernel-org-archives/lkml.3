Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaH1PLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:11:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37332 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbaH1PLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:11:30 -0400
Date: Thu, 28 Aug 2014 16:11:21 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lorenzo.pieralisi@arm.com
Subject: Re: [RESEND PATCH] ARM: dts: make arch-timer always on in rk3288 soc
Message-ID: <20140828151121.GM14650@leverpostej>
References: <1409190017-12656-1-git-send-email-kever.yang@rock-chips.com>
 <20140828091758.GB14650@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828091758.GB14650@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 10:17:58AM +0100, Mark Rutland wrote:
> Hi Kever,
> 
> On Thu, Aug 28, 2014 at 02:40:17AM +0100, Kever Yang wrote:
> > We need use the hrtimer, which need the arch-timer to be 'always-on'
> 
> I asked a question on the last posting [1]. Can you please confirm
> either way?
> 
> Thanks,
> Mark.
> 
> [1] lists.infradead.org/pipermail/linux-arm-kernel/2014-August/282327.html

To clarify: if there are low power states that the CPU can enter where
we lose state, then this patch isn't correct.

A more general approach would be to enable the broadcast hrtimer for
arm, as has been done for arm64.

See commit 5d1638acb9f6 (tick: Introduce hrtimer based broadcast) which
introduced the broadcast hrtimer, and commit 9358d755bd5c (arm64:
kernel: initialize broadcast hrtimer based clock event device) which
added the requisite plumbing for arm64.

Mark.

> 
> > Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> > ---
> > 
> >  arch/arm/boot/dts/rk3288.dtsi | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> > index 5950b0a..698e6ea 100644
> > --- a/arch/arm/boot/dts/rk3288.dtsi
> > +++ b/arch/arm/boot/dts/rk3288.dtsi
> > @@ -76,6 +76,7 @@
> >  			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
> >  			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
> >  		clock-frequency = <24000000>;
> > +		always-on;
> >  	};
> >  
> >  	i2c1: i2c@ff140000 {
> > -- 
> > 1.9.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe devicetree" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
