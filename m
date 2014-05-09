Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaEIMqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:46:24 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47837 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaEIMqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:46:21 -0400
Message-ID: <1399639530.8165.32.camel@iivanov-dev>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>
Date: Fri, 09 May 2014 15:45:30 +0300
In-Reply-To: <20140424181829.GA19254@joshc.qualcomm.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
	 <20140423214626.GA3215@joshc.qualcomm.com>
	 <20140423233621.GM17066@sonymobile.com>
	 <20140424181829.GA19254@joshc.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Thu, 2014-04-24 at 13:18 -0500, Josh Cartwright wrote:
> On Wed, Apr 23, 2014 at 04:36:22PM -0700, Courtney Cavin wrote:
> > On Wed, Apr 23, 2014 at 11:46:26PM +0200, Josh Cartwright wrote:
> > > On Tue, Apr 22, 2014 at 05:31:49PM -0700, Courtney Cavin wrote:
> [..]

<snip>
> 
> 	$ git grep spmi-slave-container arch/arm/boot/dts
> 	arch/arm/boot/dts/qcom/msm-pm8019.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8019.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8110.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8110.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8226.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8226.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8841.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8841.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8916.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8916.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8941.dtsi:	spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pm8941.dtsi:	spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pma8084.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pma8084.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pmd9635.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pmd9635.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pmi8962.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pmi8962.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pmiplutonium.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pmiplutonium.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pmplutonium.dtsi:		spmi-slave-container;
> 	arch/arm/boot/dts/qcom/msm-pmplutonium.dtsi:		spmi-slave-container;
> 
> [..]
> > > > +static const struct of_device_id pm8x41_id_table[] = {
> > > > +	{ .compatible = "qcom,pm8841", },
> > > > +	{ .compatible = "qcom,pm8941", },
> > > > +	{},
> > > > +};
> > > > +MODULE_DEVICE_TABLE(of, pm8x41_id_table);
> > > 
> > > I'm thinking we should probably have a generic compatible entry as well,
> > > "qcom,pmic-qpnp" or similar.  We should still specify in the binding
> > > that PMIC slaves specify a version-specific string as well as the
> > > generic string.  That is, a slave should have:
> > > 
> > > 	compatible = "qcom,pm8841", "qcom,pmic-qpnp";
> > > 
> > > ...in case we would ever need to differentiate in the future.
> > > 
> > > (I recall that in a previous version I had done this, but I don't
> > > remember why I had changed it..)
> >
> > I gave this some thought but came to the conclusion that there is no
> > benefit of adding a generic compatible to a new binding.  Please clarify
> > a use-case where this would be ... useful.
> 
> Having a generic compatible entry allows for easily supporting new PMICs
> without having to add yet another vacuous entry in the ID table.  In
> this case I think it's perfectly acceptable given that this driver isn't
> really defining a programming model for a specific device, but rather
> acting much more like a bus.
> 
> Requiring a specific PMIC listed before a generic one allows us an
> escape hatch in the future if for some reason we need to add a quirk for
> a specific PMIC.

Is there a conclusion on this issue? I am voting for generic name :-)
"qcom,pm-qpnp".

Further complication is that several sub function drivers expect to
runtime detect the exact version of the controller ("qcom, qpnp-iadc",
"qcom, qpnp-vadc", "qcom, qpnp-linear-charger").  This is realized by the
exported function of the driver "qcom, qpnp-revid". Would it be good
idea to merge qpnp-revid and "qcom,pm-qpnp" driver?

Regards,
Ivan

> 
>   Josh
> 
> [1]: git://codeaurora.org/quic/la/kernel/msm-3.10#msm-3.10
> 


