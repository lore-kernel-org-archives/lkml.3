Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaI3WOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:14:35 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11309 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaI3WOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:14:33 -0400
Date: Tue, 30 Sep 2014 15:14:41 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Suman Anna <s-anna@ti.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>
Subject: Re: [PATCH v4] hwspinlock: qcom: Add support for Qualcomm HW Mutex
 block
Message-ID: <20140930221440.GW28481@sonymobile.com>
References: <1412051728-3289-1-git-send-email-bjorn.andersson@sonymobile.com>
 <542B2523.7050001@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <542B2523.7050001@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Sep 14:48 PDT 2014, Suman Anna wrote:

> Hi Bjorn,
> 

Thanks for the review, I didn't find the generic binding until after I sent
this out.

> On 09/29/2014 11:35 PM, Bjorn Andersson wrote:

[..]

> > diff --git a/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt

[..]

> > +- qcom,num-locks:
> > +	Usage: required
> > +	Value type: <u32>
> > +	Definition: the number of locks/mutex available in this block
> 
> Please use the common hwlock-num-locks property defined in the common
> bindings, instead of a qcom specific property name.
> 

I'll update this and send out a new version as soon as the generic binding have
settled.

> > +
> > +Example:
> > +
> > +	hwlock@fd484000 {
> > +		compatible = "qcom,tcsr-mutex";
> > +		reg = <0xfd484000 0x1000>;
> > +		reg-names = "mutex-base";
> > +		qcom,num-locks = <32>;
> 
> You also need to add the #hwlock-cells = <1>, without which you won't be
> able to parse a client user's lock id.
> 

Yeah, I noticed.

[..]

> > diff --git a/drivers/hwspinlock/qcom_hwspinlock.c b/drivers/hwspinlock/qcom_hwspinlock.c

[..]

> > +static int qcom_hwspinlock_probe(struct platform_device *pdev)
> > +{

[..]

> > +
> > +	ret = hwspin_lock_register(bank, &pdev->dev, &qcom_hwspinlock_ops,
> > +						BASE_ID, num_locks);
> 
> I had also done the registration for OMAP hwspinlock driver using a
> constant id in my v5, but had revised it based on Ohad's review comment,
> so you may have to revise here as well. Please see [1] for details.
> 

Okay, I can add that too.

> > +	if (ret)
> > +		pm_runtime_disable(&pdev->dev);
> > +
> > +	return ret;
> > +}
> > +

[..]

> [1] https://patchwork.kernel.org/patch/4096881/

Regards,
Bjorn
