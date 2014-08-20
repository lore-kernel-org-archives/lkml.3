Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaHTWKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:10:30 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15839 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbaHTWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:10:28 -0400
Date: Wed, 20 Aug 2014 15:10:14 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Daniel <delta.tatham@me.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] pinctrl: Device tree bindings for Qualcomm pm8xxx
 gpio block
Message-ID: <20140820221013.GC16274@sonymobile.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
 <1407771634-14946-2-git-send-email-iivanov@mm-sol.com>
 <ED4952FE-A292-4724-9283-B5226AB20E3E@me.com>
 <1408346162.2695.33.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1408346162.2695.33.camel@iivanov-dev>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18 Aug 00:16 PDT 2014, Ivan T. Ivanov wrote:

> On Sat, 2014-08-16 at 16:24 +0100, Daniel wrote:
> > @Ivan: sorry about the double post.
> > 
> > Am 11.08.2014 um 16:40 schrieb Ivan T. Ivanov <iivanov@mm-sol.com>:
[...]
> > > +#define PMIC_GPIO_PULL_UP_30		1
> > > +#define PMIC_GPIO_PULL_UP_1P5		2
> > > +#define PMIC_GPIO_PULL_UP_31P5		3
> > > +#define PMIC_GPIO_PULL_UP_1P5_30	4
> > 
> > Looking at drivers/pinctrl/qcom/pinctrl-ssbi-pmic.c, shouldn't these defines start at 0?
> > e.g. #define PMIC_GPIO_PULL_UP_30 	0
> > 
> 
> Initially "bias-pull-up" was used to set this parameter. 
> Zero value for "bias-pull-up" has special meaning "...the 
> pin is connected to VDD...". So values in DTS have to have
> offset by one. Micro Amps are non-standard for pull-ups, 
> thats why I have changed this to "qcom,pull-up-strength", but I 
> have made mistake in config_set function. Following patch should 
> fix the issue. I will send updated version soon.
> 

The bias-pull-up is read as u32 and 0 means that it's not pull-up, therefor i
shifted them all. Sorry about that.

Now that we have this in a separate property there's no point in such
"trickery" and  we should make them follow the register values, i.e:
#define PM8XXX_GPIO_BIAS_PU_30          0
#define PM8XXX_GPIO_BIAS_PU_1P5         1
#define PM8XXX_GPIO_BIAS_PU_31P5        2
#define PM8XXX_GPIO_BIAS_PU_1P5_30      3

I find it cleaner and we don't need the translation.

> > However, I still cannot get any data from those 2 pins if I export them through /sys/class/gpio...
> 

Reading should work, but most other gpio operations was off by one it seems. I
have corrected this (and other reported things) and will send out a new version
soon.

> -			pin->bias = arg - PM8XXX_GPIO_BIAS_PU_30;
> +			pin->bias = arg - PMIC_GPIO_PULL_UP_30;

If we just make it follow the register value (starting at 0) we just use arg
straight off.

Regards,
Bjorn
