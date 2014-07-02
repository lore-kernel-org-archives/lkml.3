Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaGBIn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:43:59 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55158 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaGBIn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:43:57 -0400
Message-ID: <1404290605.3622.6.camel@iivanov-dev>
Subject: Re: [Patch v7 3/3] usb: dwc3: qcom: Add device tree binding
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Andy Gross <agross@codeaurora.org>, jackp@codeaurora.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 02 Jul 2014 11:43:25 +0300
In-Reply-To: <CAL_JsqLjjDV50x5LCDeySvV0u4U1om-3KDkFHMd5WouC=eV8kw@mail.gmail.com>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
	 <1404144233-17222-4-git-send-email-agross@codeaurora.org>
	 <CAL_JsqJTO4htxHMVtMG6mGLmgRtQ7igE1OCX_jXM4xabN76ntg@mail.gmail.com>
	 <20140701180114.GA2082@qualcomm.com>
	 <CAL_JsqLjjDV50x5LCDeySvV0u4U1om-3KDkFHMd5WouC=eV8kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Tue, 2014-07-01 at 14:47 -0500, Rob Herring wrote:
> On Tue, Jul 1, 2014 at 1:01 PM, Andy Gross <agross@codeaurora.org> wrote:
> > On Tue, Jul 01, 2014 at 12:04:35AM -0500, Rob Herring wrote:

<snip>

> > <snip>
> >
> >> > +
> >> > +                       ranges;
> >> > +
> >> > +                       status = "disabled";
> >> > +
> >> > +                       dwc3@11000000 {
> >> > +                               compatible = "snps,dwc3";
> >>
> >> This sub-node is just wrong. Why can't you have a single node with '
> >> "qcom,dwc3", "snps,dwc3" ' for the compatible property? All you are
> >> adding here is clocks. Does the Synopsys block have no clocks?
> >>
> >> I guess this is copied from other broken dwc3 bindings... That doesn't
> >> mean you have to copy it.
> >
> > The dwc3 core does not deal with clocks.  That is why everyone has a wrapper.
> > That, in addition to pm, has to be handled from the wrapper.  That's my take
> > anyway.  I am sure Felipe can speak more to this.
> 
> That is a Linux driver issue which is irrelevant to the binding.

DWC3 IP core from Synopsys is the same across SoC's (OMAP, Exynos..),
vendors are adding glue IP to provide necessary clocks and voltages. 
I think that the DT bindings properly reflect this fact.

Regards,
Ivan 

> 
> Rob


