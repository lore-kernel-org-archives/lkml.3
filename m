Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3LLLuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:50:12 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:44354 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3LLLuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:50:09 -0500
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2013 06:50:09 EST
Date: Thu, 12 Dec 2013 06:50:03 -0500
From: Matt Porter <mporter@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Kamil Debski <k.debski@samsung.com>,
        Linaro Patches <patches@linaro.org>, Tomasz Figa <t.figa@samsung.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/9] phy: add phy_get_bus_width()/phy_set_bus_width()
 calls
Message-ID: <20131212115003.GB20773@beef>
References: <1386847117-21240-1-git-send-email-mporter@linaro.org>
 <1386847117-21240-2-git-send-email-mporter@linaro.org>
 <20131212112715.GK4360@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212112715.GK4360@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:27:15AM +0000, Russell King wrote:
> On Thu, Dec 12, 2013 at 06:18:29AM -0500, Matt Porter wrote:
> >  /**
> > + * struct phy_attrs - represents phy attributes
> > + * @bus_width: Data path width implemented by PHY
> > + */
> > +struct phy_attrs {
> > +	u32			bus_width;
> 
> Why u32?

Kishon suggested it and I changed it on this rev...forgetting about the
error path below.

> >  int phy_power_off(struct phy *phy);
> > +static inline u32 phy_get_bus_width(struct phy *phy)
> > +{
> > +	return phy->attrs.bus_width;
> ...
> >  
> > +static inline u32 phy_get_bus_width(struct phy *phy)
> > +{
> > +	return -ENOSYS;
> 
> Why u32, especially as you're returning a negative number here.
> 
> If the bus width is a small integer (I'm assuming you don't have up to
> 2^30 bus signals) then what's wrong with it being an 'int' ?

Yes, very correct...it's expected to always be a small positive integer
value or zero (when not populated as it's optional). I agree it should
go back to 'int' especially due to the negative value when GENERIC_PHY
isn't enabled.

-Matt
