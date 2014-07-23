Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaGWIs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:48:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24291 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757177AbaGWIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:48:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+NbXb9CPAi4pPDP3vF1/Sg
Date: Wed, 23 Jul 2014 01:46:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: balbi@ti.com, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: dra: dt-bindings: Fix pull enable/disable
Message-ID: <20140723084657.GA22006@atomide.com>
References: <1406043594-14181-1-git-send-email-nm@ti.com>
 <20140722164752.GJ20588@saruman.home>
 <53CEAE0F.9080901@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CEAE0F.9080901@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140722 11:34]:
> On 07/22/2014 11:47 AM, Felipe Balbi wrote:
> > On Tue, Jul 22, 2014 at 10:39:54AM -0500, Nishanth Menon wrote:
> >> The DRA74/72 control module pins have a weak pull up and pull down.
> >> This is configured by bit offset 17. if BIT(17) is 1, a pull up is
> >> selected, else a pull down is selected.
> >>
> >> However, this pull resisstor is applied based on BIT(16) -
> >> PULLUDENABLE - if BIT(18) is *0*, then pull as defined in BIT(17) is
> >> applied, else no weak pulls are applied. We defined this in reverse.
> >>
> >> Reference: Table 18-5 (Description of the pad configuration register
> >> bits) in Technical Reference Manual Revision (DRA74x revision Q:
> >> SPRUHI2Q Revised June 2014 and DRA72x revision F: SPRUHP2F - Revised
> >> June 2014)
> >>
> >> Fixes: 6e58b8f1daaf1a ("ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board")
> >> Signed-off-by: Nishanth Menon <nm@ti.com>
> >> ---
> > 
> > Tested on an upcoming board.
> > 
> > Tested-by: Felipe Balbi <balbi@ti.com>
> > Acked-by: Felipe Balbi <balbi@ti.com>
> > 
> > 
> Felipe,
> Thanks.
> 
> Tony,
> 
> If you could consider this for the rc cycle it might be great(as well
> as for stable). The pull direction error can cause all kinds of
> Pull-down Vs Pull-Up contention with severe risk for certain IP
> reliability.

Yes this is a good one for the -rc cycle, applying into
omap-for-v3.16/fixes.

Regards,

Tony
