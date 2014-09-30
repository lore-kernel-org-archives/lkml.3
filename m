Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaI3FB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:01:56 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6805 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbaI3FBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:01:54 -0400
Date: Mon, 29 Sep 2014 22:02:04 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: DT: apq8064: add rpm support
Message-ID: <20140930050203.GG28481@sonymobile.com>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org>
 <5429DA95.80505@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5429DA95.80505@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29 Sep 15:17 PDT 2014, Stephen Boyd wrote:

> On 09/29/14 02:14, Srinivas Kandagatla wrote:
> > @@ -246,6 +247,24 @@
> >  			#reset-cells = <1>;
> >  		};
> >  
> > +		apcs: syscon@2011000 {
> > +			compatible = "syscon";
> > +			reg = <0x2011000 0x1000>;
> > +		};
> 
> This is actually a clock controller block that hw designers decided was
> good place to shove the ipc bits (because there's room!). Can we call it
> 
>                 l2cc: clock-controller@2011000 {
>                         compatible = "syscon";
>                         reg = <0x2011000 0x1000>;
>                 };
> 
> Eventually I'll add the specific krait compatible when we merge krait
> clock support:
> 
>                 l2cc: clock-controller@2011000 {
>                         compatible = "qcom,kpss-gcc", "syscon";
>                         reg = <0x2011000 0x1000>;
>                         clock-output-names = "acpu_l2_aux";
>                 };
> 

As long as we can get hold of the regmap that would be fine. I pressume the
idea is to have the kpss-gcc using syscon, just like the rpm. But hopefully the
syscon patches that are floating around (merged?) will allow any driver to
expose a "syscon regmap".

> > +
> > +		rpm@108000 {
> > +			compatible	= "qcom,rpm-apq8064";
> > +			reg		= <0x108000 0x1000>;
> > +			qcom,ipc = <&apcs 0x8 2>;
> 
> There are actually 3 ipc bits. I guess if we ever have to use the other
> two we'll extend this binding to have the other bits specified some
> other way?

I haven't seen any indications of us using more than this bit. If we want to do
that, we could simply make it <&apcs 8 2 &apcs 8 3 &apcs 8 4> (or whatever
those indices are). That way this should be easy it keep compatible.

Regards,
Bjorn
