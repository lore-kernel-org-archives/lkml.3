Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbaDXSV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:21:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41617 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385AbaDXSVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:21:54 -0400
Date: Thu, 24 Apr 2014 13:18:29 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20140424181829.GA19254@joshc.qualcomm.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
 <20140423214626.GA3215@joshc.qualcomm.com>
 <20140423233621.GM17066@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423233621.GM17066@sonymobile.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:36:22PM -0700, Courtney Cavin wrote:
> On Wed, Apr 23, 2014 at 11:46:26PM +0200, Josh Cartwright wrote:
> > On Tue, Apr 22, 2014 at 05:31:49PM -0700, Courtney Cavin wrote:
[..]
> > One thing that I had meant to do is rename this thing.  Nothing about
> > this is PM8841/PM8941 specific at all.  It should apply equally to all
> > Qualcomm's PMICs which implement QPNP.
> > 
> > Perhaps a better name would be "qcom-pmic-qpnp".
>
> What's a QPNP?  Really.  I've heard you speak about it before as being a
> definition of the register layout for interrupts, but I have no
> documentation on it.

QPNP is effectively (as I explained before) a partitioning scheme for
dividing the SPMI extended register space up into logical pieces, and
set of fixed register locations/definitions within these regions, with
some of these regions specifically used for interrupt handling.

> I would argue here from my understanding that this driver isn't specific
> to QPNP either.  With that in mind we could just go with
> "qcom-pmic-spmi".  In fact just "spmi-ext" would not be incorrect, as
> this driver has little to do with PMICs at all.

I'm actually not opposed to either of those suggested names.

> My point here is that we can easily make this into something very
> generic, but that only causes problems in the future when it's not
> "generic enough", and we have to add quirks.

Yes, this is why I'd still like to require having the specific PMIC
listed in the slave node's compatible string in front of a "generic"
one.  Without a perfect crystal ball, it's the best we have.

> If in the future Qualcomm releases a pm8A41, and it's qpnp, but not
> spmi, or spmi, but not 'ext', then we need to either change this
> driver dramatically, or write a new one.  I like keeping this driver
> name specific to what we know it supports.  We can rename it in the
> future if deemed appropriate, but I'd rather not make it something
> that which turns out to be wrong at some later point.

I don't necessarily disagree with the strategy, however, if you take a
look at the downstream msm-3.10 tree[1], you'll see that there are
already quite a few other PMICs that could be made to leverage this
driver with likely no changes (downstream the equivalent is a dt node
tagged spmi-slave-container):

	$ git grep spmi-slave-container arch/arm/boot/dts
	arch/arm/boot/dts/qcom/msm-pm8019.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8019.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8110.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8110.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8226.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8226.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8841.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8841.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8916.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8916.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8941.dtsi:	spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pm8941.dtsi:	spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pma8084.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pma8084.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pmd9635.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pmd9635.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pmi8962.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pmi8962.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pmiplutonium.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pmiplutonium.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pmplutonium.dtsi:		spmi-slave-container;
	arch/arm/boot/dts/qcom/msm-pmplutonium.dtsi:		spmi-slave-container;

[..]
> > > +static const struct of_device_id pm8x41_id_table[] = {
> > > +	{ .compatible = "qcom,pm8841", },
> > > +	{ .compatible = "qcom,pm8941", },
> > > +	{},
> > > +};
> > > +MODULE_DEVICE_TABLE(of, pm8x41_id_table);
> > 
> > I'm thinking we should probably have a generic compatible entry as well,
> > "qcom,pmic-qpnp" or similar.  We should still specify in the binding
> > that PMIC slaves specify a version-specific string as well as the
> > generic string.  That is, a slave should have:
> > 
> > 	compatible = "qcom,pm8841", "qcom,pmic-qpnp";
> > 
> > ...in case we would ever need to differentiate in the future.
> > 
> > (I recall that in a previous version I had done this, but I don't
> > remember why I had changed it..)
>
> I gave this some thought but came to the conclusion that there is no
> benefit of adding a generic compatible to a new binding.  Please clarify
> a use-case where this would be ... useful.

Having a generic compatible entry allows for easily supporting new PMICs
without having to add yet another vacuous entry in the ID table.  In
this case I think it's perfectly acceptable given that this driver isn't
really defining a programming model for a specific device, but rather
acting much more like a bus.

Requiring a specific PMIC listed before a generic one allows us an
escape hatch in the future if for some reason we need to add a quirk for
a specific PMIC.

  Josh

[1]: git://codeaurora.org/quic/la/kernel/msm-3.10#msm-3.10

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
