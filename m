Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbaJXPXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:23:35 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10868 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618AbaJXPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:23:32 -0400
Date: Fri, 24 Oct 2014 08:23:51 -0700
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
Message-ID: <20141024152350.GD28611@sonymobile.com>
References: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412672510.1027.57.camel@iivanov-dev>
 <20141007184640.GB31125@sonymobile.com>
 <1412761807.13569.12.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1412761807.13569.12.camel@iivanov-dev>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08 Oct 02:50 PDT 2014, Ivan T. Ivanov wrote:

> On Tue, 2014-10-07 at 11:46 -0700, Bjorn Andersson wrote:
> > On Tue 07 Oct 02:01 PDT 2014, Ivan T. Ivanov wrote:
> > 
> > > 
> > > Hi Bjorn,
> > > 
> > > On Mon, 2014-10-06 at 18:11 -0700, Bjorn Andersson wrote:
[..]
> > > >  create mode 100644 drivers/input/misc/pm8941-pwrkey.c
> > > 
> > > Any reason why we cannot reuse pm8xxx-pwrkey driver? It have been
> > > converted to regmap already. 
> > > 
> > 
> > The boilerplate code is the same,
> 
> The boilerplate code is almost 100% :-)
> 
> >  but configuration registers have different
> > layout and values written in them are different. 
> 
> We talk about 3 registers and 2 bit defines. struct regmap_field
> should be able to help here.
> 

You're totally right, we could rewrite the driver to use regmap_field and make
the rest of the differences conditional. In my eyes we end up with two drivers
in one file - but it can be done.

A difference however is that in pm8941 the ps hold behavious (reboot vs power
off) is controlled by this same block. So I have an additional patch that adds
a restart handler here that sets the pmic in the right state before we pull
pshold (but I haven't been able to test it properly).

In pm8xxx this is handled in the pmic misc block and does not belong in this
driver.

[..]
> > 
> > Maybe if we introduce some vagueness related to interrupts in the dt binding
> > documentation for pm8xxx we could simply reuse that binding.
> > 
> 
> I would not say vagueness, we just can say that pm8941 did not have
> second interrupt?
> 

I don't like having conditional documentation - it's not only that the second
interrupt is missing, the first one have different meaning. But you're right
that it's a minor thing and can be done.

Regards,
Bjorn
