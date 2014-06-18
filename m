Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaFRPRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:17:01 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41596 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFRPQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:16:59 -0400
Date: Wed, 18 Jun 2014 16:16:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pwm@vger.kernel.org, "kernel@stlinux.com" <kernel@stlinux.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, ajitpal.singh@st.com,
        thierry.reding@gmail.com, Maxime Coquelin <maxime.coquelin@st.com>
Subject: Re: [PATCH 1/7] ARM: stih407: Add DT nodes for for PWM
Message-ID: <20140618151652.GC15956@lee--X1>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <CAG374jCGhjACBr1a86_W6wQYWq8_CofwSFxZO+4j=3aHQC2nmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG374jCGhjACBr1a86_W6wQYWq8_CofwSFxZO+4j=3aHQC2nmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Gabriel Fernandez wrote:

> Hi Lee,
> minor remark below..
> 
> On 18 June 2014 16:52, Lee Jones <lee.jones@linaro.org> wrote:
> > Supply top level nodes for the STiH407 based development boards.
> > The Pinctrl configuration has already been applied, so the only
> > missing piece of the DT puzzle is for a board's DTB to enable
> > the nodes.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/stih407.dtsi | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
> > index 4f9024f..6b43ba2 100644
> > --- a/arch/arm/boot/dts/stih407.dtsi
> > +++ b/arch/arm/boot/dts/stih407.dtsi
> > @@ -259,5 +259,32 @@
> >
> >                         status = "disabled";
> >                 };
> > +
> > +               /* COMMS PWM Module */
> > +               pwm0: pwm@9810000 {
> > +                       compatible      = "st,sti-pwm";
> > +                       status          = "disabled";
> > +                       #pwm-cells      = <2>;
> > +                       reg             = <0x9810000 0x68>;
> > +                       pinctrl-names   = "default";
> > +                        pinctrl-0      = <&pinctrl_pwm0_chan0_default>;
> del space

Fixing, thanks.

> > +                       clock-names     = "pwm";
> > +                       clocks          = <&clk_sysin>;
> > +               };
> > +
> > +               /* SBC PWM Module */
> > +               pwm1: pwm@9510000 {
> > +                       compatible      = "st,sti-pwm";
> > +                       status          = "disabled";
> > +                       #pwm-cells      = <2>;
> > +                       reg             = <0x9510000 0x68>;
> > +                       pinctrl-names   = "default";
> > +                       pinctrl-0       = <&pinctrl_pwm1_chan0_default
> > +                                       &pinctrl_pwm1_chan1_default
> > +                                       &pinctrl_pwm1_chan2_default
> > +                                       &pinctrl_pwm1_chan3_default>;
> > +                       clock-names     = "pwm";
> > +                       clocks          = <&clk_sysin>;
> > +               };
> >         };
> >  };
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
