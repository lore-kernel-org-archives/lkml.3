Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3HNOoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:44:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33690 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab3HNOoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:44:32 -0400
Message-ID: <1376491467.18617.41.camel@hornet>
Subject: Re: [PATCH v3 2/5] ARM: dts: add reference voltage property for MXS
 LRADC
From: Pawel Moll <pawel.moll@arm.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Hector Palacios <hector.palacios@digi.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "marex@denx.de" <marex@denx.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Date: Wed, 14 Aug 2013 15:44:27 +0100
In-Reply-To: <520AA3CD.1040008@kernel.org>
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>
	 <1374501843-19651-3-git-send-email-hector.palacios@digi.com>
	 <520AA3CD.1040008@kernel.org>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 14 Aug 2013 14:44:28.0101 (UTC) FILETIME=[C72B5750:01CE98FC]
X-MC-Unique: 113081415443000101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 22:23 +0100, Jonathan Cameron wrote:
> On 07/22/13 15:04, Hector Palacios wrote:
> > Some LRADC channels have fixed pre-dividers so they can measure
> > different voltages at full scale. The reference voltage allows to
> > expose a scaling attribute through the IIO sysfs so that a user can
> > compute the real voltage out of a measured sample value.
> > 
> > diff --git a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> > index 4688205..6ec485c 100644
> > --- a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> > +++ b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> > @@ -1,9 +1,12 @@
> >  * Freescale i.MX28 LRADC device driver
> >  
> >  Required properties:
> > -- compatible: Should be "fsl,imx28-lradc"
> > +- compatible: "fsl,imx28-lradc", "fsl,imx23-lradc"
> >  - reg: Address and length of the register set for the device
> >  - interrupts: Should contain the LRADC interrupts
> > +- fsl,vref: Reference voltage (in mV) for each LRADC channel. This is the
> > +	    maximum voltage that can be measured at full scale in each channel
> > +	    considering fixed pre-dividers.

So, let me try to rephrase what I read above.

There's an ADC with X channels. And there's a reference voltage source
(one?). Now, each of the ADC channels have a (different?) voltage
divider, taking the voltage from the reference source and feeding it to
the ADC comparator. How much am I wrong?

If I'm not wrong at all, I'd say that the reference source could be
described as a standard fixed regulator
(Documentation/devicetree/bindings/regulator/fixed-regulator.txt) and
the ADC node should have some king of "reference-supply" phandle to the
regulator node. Now, if the dividers factors are *really* fixed, the
driver could know about them and calculate the effective reference
voltage on its own, couldn't it?

Let me repeat the "DT standard disclaimer": the tree, in general, should
describe the way components are *wired up*, not much more.

Pawel


