Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197Ab3HHJ0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:26:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59921 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934118Ab3HHJ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:26:19 -0400
Date: Thu, 8 Aug 2013 10:26:15 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Julius Werner <jwerner@chromium.org>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register
 handling
Message-ID: <20130808092615.GF14648@e106331-lin.cambridge.arm.com>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
 <20130807163045.GK28558@e106331-lin.cambridge.arm.com>
 <CAODwPW9DmVdzHbHN0NUK0fYUNw0tj2ktyh-20no30r14_JayFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAODwPW9DmVdzHbHN0NUK0fYUNw0tj2ktyh-20no30r14_JayFQ@mail.gmail.com>
Thread-Topic: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register
 handling
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 06:06:05PM +0100, Julius Werner wrote:
> > This breaks compatibility, both for an old kernel and a new dt and a new
> > kernel with an old dt. Is anyone using these bindings?
> 
> They only affect Samsung SoCs and have only been upstream for half a
> year, so I doubt it's heavily used.

I'm not sure everyone will be happy with that line.

> 
> > Why are we describing fewer registers now? Are they described elsewhere?
> >
> > The dt should describe the device, not only the portion of it Linux
> > wants to use right now.
> 
> This only ever described a small section of the huge set of PMU
> registers anyway. Before it described up to three registers
> controlling different PHYs (using hardcoded offsets in the code to
> later find the right one)... with my patch every PHY's DT entry only
> describes the one register concerning itself, which makes more sense
> in my opinion. It will also prevent the register descriptions in
> different DT entries from overlapping.
> 

I'm not sure I understand. The old documentation referred to the
USBDEVICE_PHY_CONTROL and USBHOST_PHY_CONTROL registers for a phy, and
your new version only refers to (usb device) PHY_CONTROL. Regardless of
multiple phys, you're suggesting that we describe less of each phy.
That seems like taking away usable information. Unless I've
misunderstood?

Ideally, we'd describe the whole set of registers and linkages to phys,
even if Linux doesn't ahppen to use that information right now.

Thanks,
Mark.
