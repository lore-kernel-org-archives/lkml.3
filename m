Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaJHP5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:57:35 -0400
Received: from 71-19-161-253.dedicated.allstream.net ([71.19.161.253]:54548
	"EHLO nsa.nbspaymentsolutions.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755309AbaJHP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:57:32 -0400
From: Bill Pringlemeir <bpringlemeir@nbsps.com>
To: stefan@agner.ch (Stefan Agner)
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, b35083@freescale.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: vf500/vf610: support VF500 SoC
Organization: NBS Payment Solutions
References: <1412261724-11073-1-git-send-email-stefan@agner.ch>
	<8882221.sfQOLcQs3p@wuerfel>
	<20f4e3a1932756c92443d380a7f42f56@agner.ch>
Date: Wed, 08 Oct 2014 11:57:30 -0400
Message-ID: <87r3yid05x.fsf@nbsps.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  2 Oct 2014, stefan at agner.ch wrote:

> Am 2014-10-02 17:28, schrieb Arnd Bergmann:
>> On Thursday 02 October 2014 16:55:23 Stefan Agner wrote:
>>> The VF500 is essentially the same SoC, but with only one core and
>>> without L1 cache. The VF610 is therefore a superset of the VF500.
>>> Move allmost all periperals to vf500.dtsi which is then included
>>> and enhanced by vf610.dtsi.
>>>
>>> Signed-off-by: Stefan Agner <stefan at agner.ch>
>>> ---
>>> Somehow using -M -B switches create a unapplyable patch, hence I
>>> generated one without those options. Sorry about that.
>>>
>>> arch/arm/boot/dts/vf500.dtsi | 498
>>> ++++++++++++++++++++++++++++++++++++++++++
>>> arch/arm/boot/dts/vf610.dtsi | 507
>>> +------------------------------------------
>>> 2 files changed, 510 insertions(+), 495 deletions(-)
>>> create mode 100644 arch/arm/boot/dts/vf500.dtsi

>> I think it would be better to create one extra file that contains the
>> common parts and is included by both vf500 and vf610.

> I also thought about that. But when looking at the product variants,
> its clear that VF500 really contains only features, which are part of
> all other Vybrids (VF3xx series excluded, but these series is not
> really suitable for Linux due to lack of external memory). So
> vf500.dtsi would always be a oneliner (#include <vf.dtsi>).

> Also I disliked this idea because of the somewhat unclear naming
> (vf.dtsi? vfxxx.dtsi?)

Well, I see points from both sides.  I would just like to point out
there maybe more variants than you may think,

 1. With/without security
    Secure parts have a CAAM engine and an SNVS real-time clock.  I
    guess this is the same as the iMX6.
 2. With/without M4 (and some camera features)
    This is the Vf5xx vs VF6xx
 3. With/without L2 cache
    Some VF5xx have the L2
 4. Automotive has an OpenVG engine (plus others differences).

People may not have boards with these features in the mainline.  They
maybe added later.  If Arnd's variant is Linux standard for this, then
it doesn't make sense to special case the Vybrid.  I looked briefly at
the imx6 and 'quad', 'dual-light', etc.  Whatever the current DT
structure is for those, it at least doesn't jump out at me?

It looks like 'imx6sl.dtsi' and 'imx6sl.dtsi' both define the SNVS; yet
I think on some devices these are not present as it is a part option.
The Vybrid is very close SOC to the iMx6.  Note: I looked at the iMx6
for a few minutes.  I am not expert on iMx6 **AND** this is not a
critism, just an example of why Arnd's approach may have some issues.
People making changes for platform VF5xx will be prone to only put
changes in VF5xx and not the 'vf.dtsi'.  The VF6xx is most naturally a
super-set, but even within those parts there are variations.

I think a consistent layout of the includes would be valuable.
Definitely, the repeated information in the DT is bad.  Is there an
unwritten standard?  I think it would be useful to point out an example
that should be the prototype?  Do we have one?  Ie, some SOC family that
we would like as an example?  Or is this case by case?  Or maybe this is
only occurring with Freescale parts; but I doubt that.

Fwiw,
Bill Pringlemeir.
