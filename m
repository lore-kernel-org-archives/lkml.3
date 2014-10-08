Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaJHJuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:50:05 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45046 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbaJHJuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:50:01 -0400
Message-ID: <1412761807.13569.12.camel@iivanov-dev>
Subject: Re: [PATCH 0/2] Qualcomm PM8941 power key driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Wed, 08 Oct 2014 12:50:07 +0300
In-Reply-To: <20141007184640.GB31125@sonymobile.com>
References: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1412672510.1027.57.camel@iivanov-dev>
	 <20141007184640.GB31125@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 11:46 -0700, Bjorn Andersson wrote:
> On Tue 07 Oct 02:01 PDT 2014, Ivan T. Ivanov wrote:
> 
> > 
> > Hi Bjorn,
> > 
> > On Mon, 2014-10-06 at 18:11 -0700, Bjorn Andersson wrote:
> > > These patches add dt bindings and a device driver for the power key block in
> > > the Qualcomm PM8941 pmic.
> > > 
> > > Courtney Cavin (2):
> > >   input: Add Qualcomm PM8941 power key driver
> > >   input: pm8941-pwrkey: Add DT binding documentation
> > > 
> > >  .../bindings/input/qcom,pm8941-pwrkey.txt          |   43 +++++
> > >  drivers/input/misc/Kconfig                         |   12 ++
> > >  drivers/input/misc/Makefile                        |    1 +
> > >  drivers/input/misc/pm8941-pwrkey.c                 |  196 ++++++++++++++++++++
> > >  4 files changed, 252 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt
> > >  create mode 100644 drivers/input/misc/pm8941-pwrkey.c
> > 
> > Any reason why we cannot reuse pm8xxx-pwrkey driver? It have been
> > converted to regmap already. 
> > 
> 
> The boilerplate code is the same,

The boilerplate code is almost 100% :-)

>  but configuration registers have different
> layout and values written in them are different. 

We talk about 3 registers and 2 bit defines. struct regmap_field
should be able to help here.

> The pm8xxx block have separate
> interrupts for press and release events while pm8941 have one interrupt for
> both, so the pm8941 must read out the irq status bits to figure out which event
> it was.

Optional interrupt property? If both are defined hook old ISR, if its
only one hook pm8941 ISR?

> 
> Maybe if we introduce some vagueness related to interrupts in the dt binding
> documentation for pm8xxx we could simply reuse that binding.
> 

I would not say vagueness, we just can say that pm8941 did not have
second interrupt?

Regards,
Ivan

> Regards,
> Bjorn


