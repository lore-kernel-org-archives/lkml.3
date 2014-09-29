Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaI2IiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:38:22 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58337 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaI2IiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:38:19 -0400
Message-ID: <1411979902.5395.2.camel@iivanov-dev>
Subject: Re: [PATCH v2] iio: iadc: Qualcomm SPMI PMIC current ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Lee Jones <lee.jones@linaro.org>, Philippe Reynes <tremyfr@yahoo.fr>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Mon, 29 Sep 2014 11:38:22 +0300
In-Reply-To: <5426886D.4050602@kernel.org>
References: <1411567103-2380-1-git-send-email-iivanov@mm-sol.com>
		 <20140924145527.GI5729@leverpostej>
	 <1411574442.18580.95.camel@iivanov-dev>
		 <20140924170522.GL5729@leverpostej>
		 <1411638435.18580.126.camel@iivanov-dev>
		 <20140925160215.GB6531@leverpostej> <1411672895.28648.3.camel@mm-sol.com>
	 <5426886D.4050602@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-27 at 10:50 +0100, Jonathan Cameron wrote:
> On 25/09/14 20:21, Ivan T. Ivanov wrote:
> > On Thu, 2014-09-25 at 17:02 +0100, Mark Rutland wrote:
> >> On Thu, Sep 25, 2014 at 10:47:15AM +0100, Ivan T. Ivanov wrote:

<snip>

> >>
> >>>>>>> +- interrupts:
> >>>>>>> +    Usage: optional
> >>>>>>> +    Value type: <prop-encoded-array>
> >>>>>>> +    Definition: End of conversion interrupt number. If property is
> >>>>>>> +            missing driver will use polling to detect end of conversion
> >>>>>>> +            completion.
> >>>>>>
> >>>>>> Driver details shouldn't be in the binding. If the driver can poll,
> >>>>>> that's good, but it should be dropped form this description.
> >>>>>>
> >>>>>
> >>>>> Will remove driver details.
> >>>>>
> >>>>>> Is this the only interrupt?
> >>>>>>
> >>>>>
> >>>>> Yes.
> >>>>>
> >>>>>> What do you mean be "End of conversion interrupt number"? Just describe
> >>>>>> what the interrupt logically is from the PoV of the device -- interrupts
> >>>>>> is a standard property so we don't need to be too explicit about the
> >>>>>> type.
> >>>>>
> >>>>> Badly worded. Just, "End of conversion interrupt"?
> >>>>
> >>>> The part I didn't understand was what was meant by "End of conversion",
> >>>> but dropping "number" is certainly better.
> >>>
> >>> It is clear now, right? End of ADC conversion.
> >>
> >> Sorry if I'm being thick here, but it's still somewhat confusing to me.
> >> That's a consequence of me not being familiar with the HW more than
> >> anything, I'm just missing simple details regarding the model of
> >> operation, suchs as exactly what the "end of ADC conversion" entails.
> >> There are a few things that could potentially mean depending on how the
> >> HW was designed and intended to be used.
> >>
> >> Does the  device periodically sample, convert some number of values
> >> (possibly just 1), and trigger an interrupt to state that a buffer is
> >> full / values are available? Or is the interrupt triggered for some
> >> other reason?
> > 
> > Interrupt is triggered after ADC convert analog signal to digital.
> > Other details are irrelevant, I believe. 
> Often called a data ready interrupt.  However, here it is per channel
> so perhaps that description is confusing as well...

Not exactly. There is only one interrupt. Simultaneous conversions are 
not possible.

Regards,
Ivan 


