Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaJGSqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:46:30 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8648 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbaJGSq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:46:28 -0400
Date: Tue, 7 Oct 2014 11:46:41 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 0/2] Qualcomm PM8941 power key driver
Message-ID: <20141007184640.GB31125@sonymobile.com>
References: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412672510.1027.57.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1412672510.1027.57.camel@iivanov-dev>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 07 Oct 02:01 PDT 2014, Ivan T. Ivanov wrote:

> 
> Hi Bjorn,
> 
> On Mon, 2014-10-06 at 18:11 -0700, Bjorn Andersson wrote:
> > These patches add dt bindings and a device driver for the power key block in
> > the Qualcomm PM8941 pmic.
> > 
> > Courtney Cavin (2):
> >   input: Add Qualcomm PM8941 power key driver
> >   input: pm8941-pwrkey: Add DT binding documentation
> > 
> >  .../bindings/input/qcom,pm8941-pwrkey.txt          |   43 +++++
> >  drivers/input/misc/Kconfig                         |   12 ++
> >  drivers/input/misc/Makefile                        |    1 +
> >  drivers/input/misc/pm8941-pwrkey.c                 |  196 ++++++++++++++++++++
> >  4 files changed, 252 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8941-pwrkey.txt
> >  create mode 100644 drivers/input/misc/pm8941-pwrkey.c
> 
> Any reason why we cannot reuse pm8xxx-pwrkey driver? It have been
> converted to regmap already. 
> 

The boilerplate code is the same, but configuration registers have different
layout and values written in them are different. The pm8xxx block have separate
interrupts for press and release events while pm8941 have one interrupt for
both, so the pm8941 must read out the irq status bits to figure out which event
it was.

Maybe if we introduce some vagueness related to interrupts in the dt binding
documentation for pm8xxx we could simply reuse that binding.

Regards,
Bjorn
