Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaKLNzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:55:11 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43420 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaKLNzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:55:08 -0500
Date: Wed, 12 Nov 2014 13:55:00 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 02/13] ARM: STi: DT: STiH416: Add DT node for the
 stih415/6 usb2 phy
Message-ID: <20141112135500.GC20187@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-3-git-send-email-peter.griffin@linaro.org>
 <20141110104947.GT21424@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110104947.GT21424@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thanks for reviewing.

On Mon, 10 Nov 2014, Lee Jones wrote:

> On Fri, 07 Nov 2014, Peter Griffin wrote:
> 
> > This usb picophy is found on stih415/6 SoC.
> 
> Then shouldn't it live in stih41x.dtsi?

No, it is the same ip block, and underlying driver, but needs a different
compatible string as it's wired up to different sysconfig registers on the SoC.

> 
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  arch/arm/boot/dts/stih416.dtsi | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> > index 1137bdf..0f3019a 100644
> > --- a/arch/arm/boot/dts/stih416.dtsi
> > +++ b/arch/arm/boot/dts/stih416.dtsi
> > @@ -316,5 +316,14 @@
> >  
> >  			status	        = "disabled";
> >  		};
> > +
> > +		usb2_phy: usb2phy@0 {
> > +			compatible = "st,stih416-usb-phy";
> > +			#phy-cells = <0>;
> > +			st,syscfg = <&syscfg_rear>;
> > +			clocks = <&clk_sysin>;
> > +			clock-names = "osc_phy";
> > +
> 
> Remove this '\n'.

Fixed in v2.

regards,

Peter.
