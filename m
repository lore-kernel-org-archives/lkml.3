Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaGPISo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:18:44 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35210 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaGPISj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:18:39 -0400
Message-ID: <1405498694.31919.20.camel@iivanov-dev>
Subject: Re: [PATCH 2/3] pinctrl: Device tree bindings for Qualcomm pm8xxx
 gpio block
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 16 Jul 2014 11:18:14 +0300
In-Reply-To: <CAJAp7OjU=FFdGKHPqovz+qrEhDCZ3E=uOSAOFbgYyLE01C9cPg@mail.gmail.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1404782785-1824-3-git-send-email-bjorn.andersson@sonymobile.com>
	 <CACRpkdZ2hekBGe1-9GV-amqi50heghWhXJ9raW7P_Nif_Ci88g@mail.gmail.com>
	 <CAJAp7OghZoTXutxw7hAsq1XA_wAhOXDNFO0tz8u9ceQ1fD9W1w@mail.gmail.com>
	 <CACRpkdai=q3nmPk5OWQWn_UMdXmqcbFXJ90rxREBG9k6gdy88Q@mail.gmail.com>
	 <53C095EA.90000@codeaurora.org> <1405346335.13503.25.camel@iivanov-dev>
	 <53C449A3.2010404@codeaurora.org> <1405406114.13503.40.camel@iivanov-dev>
	 <CAJAp7OjU=FFdGKHPqovz+qrEhDCZ3E=uOSAOFbgYyLE01C9cPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 17:23 -0700, Bjorn Andersson wrote:
> On Mon, Jul 14, 2014 at 11:35 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> > On Mon, 2014-07-14 at 14:20 -0700, Stephen Boyd wrote:
> [..]
> >> Isn't this document only for the gpios? I think you're talking about the
> >> MPPs, which also exist on these generation of pmics. We should probably
> >> avoid mixing the two (gpios and mpps) in one binding because they're
> >> really different hardware.
> >
> > I don't know. For me "gpio" looks like function of the pin hardware.
> >
> >>
> >> >  So I will like
> >> > to keep "function" property for selecting one of the above functions.
> >> > Choosing between "normal", "paired"... options in QPNP pinctrl driver
> >> > is supported trough passing values, defined in DT header file, to
> >> > "output-high" property. Please don't kill me :-).
> >>
> >> Overloading output-high to choose the MPP mode doesn't seem to follow
> >> the generic pinconfig binding. Does output-high even take a value? Why
> >> can't we use the function property?
> >
> > No, no.  using value of the output-high|low" is just to select
> > "normal", "paired"... thing. Function selection is via "function"
> > property. Currently QPNP support following functions "gpio", "mpp-ain",
> > "mpp-aout", "mpp-cs".
> >
> 
> Hi Ivan,
> 
> From your comment I presume that you don't have access to the
> documentation for these blocks.
> 
> The pmic sports two types of pins; gpios and mpps (multi-purpose-pin).
> These are different hardware blocks; i.e. not a configuration thing.

I am looking on GPIO's hardware blocks as stripped down MPP's.

> 
> The gpios can be input, output or both and they can be configured as
> gpio, paired, function 1 or function 2 (+ some test modes). So here it
> makes sense to have the functions "gpio", "paired" and the valid
> function combinations.

I believe that MPP's also support these 'functions'.

> 
> The mpps can be input, output or both; in either digital or analog
> mode. Or they can be a current sink. When configured as analog input
> you select which adc the pin should be routed to. Here it makes sense
> to have the functions "digital", "analog" and "current-sink" I think.

My understanding is that MPP's are supporting everything which GPIO's
does, plus analog functionality. 

I don't want at the end MPP's functions to be something like:

analog-normal, analog-paired, analog-function-1, analog-function-2, 
digital-normal, digital-paired...

So better to leave normal/paired stuff as separate parameter (qcom,pair).

Plain GPIO hardware will just support 'gpio' function, while MPP's
will have 'gpio', 'analog-in', 'analog-out', 'current-sink' 

I am fine to split driver to two drivers (GPIO and MPP), which will
make code a little more clean, but I am pretty sure there will be
lot of duplication.

Regards,
Ivan


