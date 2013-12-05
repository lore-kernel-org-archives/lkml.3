Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3LEGfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 01:35:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43819 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3LEGfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 01:35:38 -0500
Message-ID: <52A01E86.50406@ti.com>
Date: Thu, 5 Dec 2013 12:04:46 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>, <balbi@ti.com>
CC: <bcousson@baylibre.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: Re: [PATCH v3 04/10] usb: dwc3: use quirks to know if a particualr
 platform doesn't have PHY
References: <1385373690-12170-1-git-send-email-kishon@ti.com> <1385373690-12170-5-git-send-email-kishon@ti.com> <20131204144027.GB21055@xps8300>
In-Reply-To: <20131204144027.GB21055@xps8300>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 04 December 2013 08:10 PM, Heikki Krogerus wrote:
> Hi guys,
> 
> Kishon, sorry I did not see this v3 set.
> 
> On Mon, Nov 25, 2013 at 03:31:24PM +0530, Kishon Vijay Abraham I wrote:
>> There can be systems which does not have an external phy, so get
>> phy only if no quirks are added that indicates the PHY is not present.
>> Introduced two quirk flags to indicate the *absence* of usb2 phy and
>> usb3 phy. Also remove checking if return value is -ENXIO since it's now
>> changed to always enable usb_phy layer.
> 
> Can you guys explain why is something like this needed? Like with
> clocks and gpios, the device drivers shouldn't need to care any more
> if the platform has the phys or not. -ENODEV tells you your platform

Shouldn't we report if a particular platform needs a PHY and not able to get
it. How will a user know if a particular controller is not working because it's
not able to get and initialize the PHYs? Don't you think in such cases it's
better to fail (and return from probe) because the controller will not work
anyway without the PHY?

Thanks
Kishon
