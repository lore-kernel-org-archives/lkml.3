Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaEUMDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:03:05 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34430 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaEUMDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:03:03 -0400
Date: Wed, 21 May 2014 08:02:57 -0400
From: Matt Porter <mporter@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/4] ARM: dts: bcm590xx: add support for GPLDO and
 VBUS regulators
Message-ID: <20140521120257.GV32082@beef>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-5-git-send-email-mporter@linaro.org>
 <20140521092913.GG6679@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521092913.GG6679@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:29:13AM +0100, Lee Jones wrote:
> > Adds additional nodes to support GPLDO1-6 and VBUS regulators which
> > are now supported in the bcm590xx regulator driver.
> > 
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> > ---
> >  arch/arm/boot/dts/bcm59056.dtsi | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> 
> I'm not going to apply this with the rest of the set.  It will have to
> go in via your normal arch/arm route.

Ok

> > diff --git a/arch/arm/boot/dts/bcm59056.dtsi b/arch/arm/boot/dts/bcm59056.dtsi
> > index dfadaaa..066adfb 100644
> > --- a/arch/arm/boot/dts/bcm59056.dtsi
> > +++ b/arch/arm/boot/dts/bcm59056.dtsi
> > @@ -70,5 +70,26 @@
> >  
> >  		vsr_reg: vsr {
> >  		};
> > +
> > +		gpldo1_reg: gpldo1 {
> > +		};
> 
> What do these empty nodes do in any case?

They instantiate regulators. The bcm590xx binding specifies the
allowable subnode names permitted here. This replaces the old method
of specifying an index or the deprecated regulator-compatible property.
The board-specific dts includes this dtsi and applies any board
constraints to a subset of regulators that need them. Unused regulators
are all disabled which is what we want.

> Don't you at least need a status property in there or something?

Not necessary for these subnodes.

-Matt

