Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaI2Kxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:53:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64382 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbaI2Kxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:53:33 -0400
Date: Mon, 29 Sep 2014 11:53:29 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "bjorn.andersson@sonymobile.com" <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH 3/4] ARM: DT: apq8064: Add USB OTG support
Message-ID: <20140929105329.GA2432@leverpostej>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411982127-8048-1-git-send-email-srinivas.kandagatla@linaro.org>
 <542933E1.8010809@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542933E1.8010809@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:26:41AM +0100, Kiran Padwal wrote:
> Hi Srinivas,
> 
> Some review are comments inline.
> 
> On Monday 29 September 2014 02:45 PM, Srinivas Kandagatla wrote:
> > This patch adds USB OTG support on USB1 of APQ8064 SOC.
> > Tested on IFC6410 with ethernet gadget.
> > 
> > Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> > ---
> >  arch/arm/boot/dts/qcom-apq8064-ifc6410.dts | 14 +++++++++
> >  arch/arm/boot/dts/qcom-apq8064.dtsi        | 46 ++++++++++++++++++++++++++++++
> >  2 files changed, 60 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
> > index d6036b8..f41fb39 100644
> > --- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
> > +++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
> > @@ -40,6 +40,11 @@
> >  			};
> >  		};
> >  
> > +		/* OTG */
> > +		usb1_phy:phy@12500000 {
> > +			status = "ok";
> 
> Its canonical value is "okay" (although in practice anything
> other than "disabled" should work).

That's not quite true, there are other "bad" values like "fail" and
"fail-sss" documented by ePAPR. In Linux, of_device_is_available errs on
the side of caution and checks for either "okay" or "ok", failing
otherwise

Regardless, please use the canonical "okay".

Mark.
