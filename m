Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbaGASBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:01:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55737 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaGASBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:01:16 -0400
Date: Tue, 1 Jul 2014 13:01:14 -0500
From: Andy Gross <agross@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, jackp@codeaurora.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch v7 3/3] usb: dwc3: qcom: Add device tree binding
Message-ID: <20140701180114.GA2082@qualcomm.com>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
 <1404144233-17222-4-git-send-email-agross@codeaurora.org>
 <CAL_JsqJTO4htxHMVtMG6mGLmgRtQ7igE1OCX_jXM4xabN76ntg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJTO4htxHMVtMG6mGLmgRtQ7igE1OCX_jXM4xabN76ntg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 12:04:35AM -0500, Rob Herring wrote:

<snip>

> > +- clock-names: Should contain the following:
> > +  "core"               Master/Core clock, have to be >= 125 MHz for SS
> > +                               operation and >= 60MHz for HS operation
> > +
> > +Optional clocks:
> > +  "iface"              System bus AXI clock.  Not present on all platforms
> 
> Really?, some platforms have a clockless bus?

Some platforms require core and interface.  The specific platform I tested on
does not have an iface clk.  I'll take a look at the ipq block diagram to see if
they did something cute, but i don't believe there is one.

> 
> > +  "sleep"              Sleep clock, used when USB3 core goes into low
> > +                               power mode (U3).
> > +
> > +Optional regulator:
> > +- gdsc-supply: phandle to the regulator from globally distributed
> > +                               switch controller
> 
> The name should reflect the name of the input, not the source.

Ok, I'll revisit this.  I took this from the original patch set.

<snip>

> > +
> > +                       ranges;
> > +
> > +                       status = "disabled";
> > +
> > +                       dwc3@11000000 {
> > +                               compatible = "snps,dwc3";
> 
> This sub-node is just wrong. Why can't you have a single node with '
> "qcom,dwc3", "snps,dwc3" ' for the compatible property? All you are
> adding here is clocks. Does the Synopsys block have no clocks?
> 
> I guess this is copied from other broken dwc3 bindings... That doesn't
> mean you have to copy it.

The dwc3 core does not deal with clocks.  That is why everyone has a wrapper.
That, in addition to pm, has to be handled from the wrapper.  That's my take
anyway.  I am sure Felipe can speak more to this.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
