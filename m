Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaIQOZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:25:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37771 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbaIQOZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:25:48 -0400
Date: Wed, 17 Sep 2014 09:25:03 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony <tony@atomide.com>
CC: <balbi@ti.com>, <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: DRA7: Add PMU nodes
Message-ID: <20140917142503.GA11856@kahuna>
References: <1408456440-30171-1-git-send-email-nm@ti.com>
 <540719FC.5070803@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <540719FC.5070803@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:39-20140903, Nishanth Menon wrote:
> On 08/19/2014 08:54 AM, Nishanth Menon wrote:
> > From: Lucas Weaver <l-weaver@ti.com>
> > 
> > DRA74x and DRA72x family of processors vary slightly in the number
> > of CPUs. So, add different instances of PMU for each of these processor
> > groups. Further, since the interrupts bypass crossbar and are directly
> > connected to GIC, mark the dts nodes with relevant information.
> > 
> > Tested with perf utility.
> > 
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Lucas Weaver <l-weaver@ti.com>
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> Hi,
> Gentle ping..

Tony,
I dont see this patch in omap-for-v3.18/dt

Is there anyway you might consider pulling this for 3.18?

Patchworks link:
https://patchwork.kernel.org/patch/4743121/

> 
> Regards,
> Nishanth Menon
> >  arch/arm/boot/dts/dra72x.dtsi |    5 +++++
> >  arch/arm/boot/dts/dra74x.dtsi |    6 ++++++
> >  2 files changed, 11 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/dra72x.dtsi b/arch/arm/boot/dts/dra72x.dtsi
> > index f1ec22f..e5a3d23 100644
> > --- a/arch/arm/boot/dts/dra72x.dtsi
> > +++ b/arch/arm/boot/dts/dra72x.dtsi
> > @@ -22,4 +22,9 @@
> >  			reg = <0>;
> >  		};
> >  	};
> > +
> > +	pmu {
> > +		compatible = "arm,cortex-a15-pmu";
> > +		interrupts = <GIC_SPI DIRECT_IRQ(131) IRQ_TYPE_LEVEL_HIGH>;
> > +	};
> >  };
> > diff --git a/arch/arm/boot/dts/dra74x.dtsi b/arch/arm/boot/dts/dra74x.dtsi
> > index a4e8bb9..3be544c 100644
> > --- a/arch/arm/boot/dts/dra74x.dtsi
> > +++ b/arch/arm/boot/dts/dra74x.dtsi
> > @@ -38,4 +38,10 @@
> >  			reg = <1>;
> >  		};
> >  	};
> > +
> > +	pmu {
> > +		compatible = "arm,cortex-a15-pmu";
> > +		interrupts = <GIC_SPI DIRECT_IRQ(131) IRQ_TYPE_LEVEL_HIGH>,
> > +			     <GIC_SPI DIRECT_IRQ(132) IRQ_TYPE_LEVEL_HIGH>;
> > +	};
> >  };
> > 
> 
> 
> -- 
> Regards,
> Nishanth Menon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards,
Nishanth Menon
