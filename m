Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3EaP2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:28:20 -0400
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:57865 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756079Ab3EaP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:28:13 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2013 11:28:13 EDT
Date: Fri, 31 May 2013 17:24:05 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Benoit Cousson <b-cousson@ti.com>, Russell King <linux@arm.linux.org.uk>,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCHv2 3/3] arm: dts: add bandgap entry for OMAP4460 devices
Message-ID: <20130531152405.GH23653@game.jcrosoft.org>
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com>
 <1368629928-6723-4-git-send-email-eduardo.valentin@ti.com>
 <5193A875.1020000@ti.com>
 <5193B9AA.7020507@ti.com>
 <20130515165726.GK22508@game.jcrosoft.org>
 <5194D123.4060403@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5194D123.4060403@ti.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13955529345901833086
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:29 Thu 16 May     , Eduardo Valentin wrote:
> On 15-05-2013 12:57, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 12:36 Wed 15 May     , Eduardo Valentin wrote:
> >> On 15-05-2013 11:23, Benoit Cousson wrote:
> >>> Hi Eduardo,
> >>>
> >>> On 05/15/2013 04:58 PM, Eduardo Valentin wrote:
> >>>> Include bandgap devices for OMAP4460 devices.
> >>>>
> >>>> Cc: "Benoît Cousson" <b-cousson@ti.com>
> >>>> Cc: Tony Lindgren <tony@atomide.com>
> >>>> Cc: Russell King <linux@arm.linux.org.uk>
> >>>> Cc: linux-omap@vger.kernel.org
> >>>> Cc: devicetree-discuss@lists.ozlabs.org
> >>>> Cc: linux-arm-kernel@lists.infradead.org
> >>>> Cc: linux-kernel@vger.kernel.org
> >>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> >>>> ---
> >>>>  arch/arm/boot/dts/omap4460.dtsi | 9 +++++++++
> >>>>  1 file changed, 9 insertions(+)
> >>>>
> >>>> diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
> >>>> index 2cf227c..e5bfbfe 100644
> >>>> --- a/arch/arm/boot/dts/omap4460.dtsi
> >>>> +++ b/arch/arm/boot/dts/omap4460.dtsi
> >>>> @@ -29,4 +29,13 @@
> >>>>  			     <0 55 0x4>;
> >>>>  		ti,hwmods = "debugss";
> >>>>  	};
> >>>> +
> >>>> +	bandgap {
> >>>> +		reg = <0x4a002260 0x4
> >>>> +			0x4a00232C 0x4
> >>>> +			0x4a002378 0x18>;
> >>>> +		compatible = "ti,omap4460-bandgap";
> >>>> +		interrupts = <0 126 4>; /* talert */
> >>>> +		ti,tshut-gpio = <86>;
> >>
> >>
> >>
> >>>
> >>> Why do you need a custom attribute for GPIO? Cannot you use the standard
> >>> one?
> >>
> >> I believe it was by your suggestion :-), during the first attempts to
> >> send this driver. But could not find the thread link :-( sorry.
> >>
> >>
> >> I guess the reasoning to mark it as a ti specific is because it will be
> >> used as IRQ line to treat thermal shutdown (in SW).
> > so use interrup-parent
> 
> 
> Jean-Christophe,
> 
> That will change the controller and break the configuration for the
> other IRQ line, coming from GIC.

put this on hold I'm preparing a fix for this
I've discuss with Grant already.

This way for me is buggy

Best Regards,
J.
> 
> >>
> >>>
> >>> Where is the gpio controller phandle?
> >>>
> >>> Usually it looks like this:
> >>>
> >>> 	gpios = <&gpio1 8 0>;
> >>>
> >>>
> >>> Regards,
> >>> Benoit
> >>>
> >>>
> >>>
> >>
> >>
> > 
> > 
> > 
> >> _______________________________________________
> >> linux-arm-kernel mailing list
> >> linux-arm-kernel@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> > 
> > 
> 
> 


