Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3JVPkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:40:49 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:55239 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab3JVPkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:40:46 -0400
Message-ID: <1382456363.2837.10.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v6 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DW PHY's
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "idos@codeaurora.org" <idos@codeaurora.org>,
        "mgautam@codeaurora.org" <mgautam@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Tue, 22 Oct 2013 18:39:23 +0300
In-Reply-To: <20131022143242.GA4691@kartoffel>
References: <1381131897-13910-1-git-send-email-iivanov@mm-sol.com>
	 <1381131897-13910-3-git-send-email-iivanov@mm-sol.com>
	 <52527D38.1070505@mm-sol.com>
	 <1381246952.24031.83.camel@iivanov-dev.int.mm-sol.com>
	 <20131022143242.GA4691@kartoffel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Tue, 2013-10-22 at 15:32 +0100, Mark Rutland wrote: 
> [...]
> 
> > > > +   phy->sleep_a_clk = devm_clk_get(phy->dev, "sleep_a");
> > >
> > > What means the "_a" in clock name?
> > 
> > They are 2 PHY's on 8074 chip. This drivers is supposed to
> > operate on PHY 0, thus sleep_a. PHY 1 is using sleep_b. Take a look
> > here http://www.spinics.net/lists/arm-kernel/msg276945.html
> 
> When you say two PHYs, do you mean the HS PHY and the SS PHY?
> 
> Or are there two HS PHYs? If so, would the other HS PHY have a sleep_b clock?

I think that this is the case.

> 
> The clock-names property should describe the clocks from the view of the device
> itself. As we're describing the PHY in isolation, rather than a big block that
> contains the PHY, the presesnce or absence of other PHYs should not affect the
> name. If the "_a" suffix is only to differentiate the instance of PHY, it
> should be dropped.


Ok. This was left from earlier platform code. I will change it.

Thanks,
Ivan

> 
> Thanks,
> Mark.
> --


