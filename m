Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbaAaXNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:13:55 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58855 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaAaXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:13:53 -0500
Date: Fri, 31 Jan 2014 15:11:59 -0800
From: Olof Johansson <olof@lixom.net>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Arm Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [RESEND PATCH] ARM: dts: bcm28155-ap: Fix Card Detection GPIO
Message-ID: <20140131231159.GA11138@quad.lixom.net>
References: <1389120821-12007-1-git-send-email-tim.kryger@linaro.org>
 <CAEPRUYo0r5YcRTYdgSNLqedVV4D0bsor7USBoxRRpBXRs7wpbw@mail.gmail.com>
 <CAAYSxhpgJwnq63fUdYBtmneRads_69c2mik8upofvAS1Y25fOA@mail.gmail.com>
 <CAEPRUYpyr2_3pfa3rqYiYPAOwJfA+0AdqyGaf5s7YiWH=zfTeA@mail.gmail.com>
 <CAAYSxhpSz8ZF_urMfQ4xdc1fhFdQC-_=9U1dvNn=EU_OoNsWbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYSxhpSz8ZF_urMfQ4xdc1fhFdQC-_=9U1dvNn=EU_OoNsWbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 10:48:40AM -0800, Tim Kryger wrote:
> On Wed, Jan 8, 2014 at 4:54 PM, Christian Daudt <bcm@fixthebug.org> wrote:
> > On Wed, Jan 8, 2014 at 4:28 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> >> On Wed, Jan 8, 2014 at 3:38 PM, Christian Daudt <bcm@fixthebug.org> wrote:
> >>> On Tue, Jan 7, 2014 at 10:53 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
> >>>> The board schematic states that the "SD_CARD_DET_N gets pulled to GND
> >>>> when card is inserted" so the polarity has been updated to active low.
> >>>>
> >>>> Polarity is now specified with a GPIO define instead of a magic number.
> >>>>
> >>>> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> >>>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> >>>> ---
> >>>>  arch/arm/boot/dts/bcm28155-ap.dts | 4 +++-
> >>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
> >>>> index 08e47c2..27dd110 100644
> >>>> --- a/arch/arm/boot/dts/bcm28155-ap.dts
> >>>> +++ b/arch/arm/boot/dts/bcm28155-ap.dts
> >>>> @@ -13,6 +13,8 @@
> >>>>
> >>>>  /dts-v1/;
> >>>>
> >>>> +#include <dt-bindings/gpio/gpio.h>
> >>>> +
> >>>>  #include "bcm11351.dtsi"
> >>>>
> >>>>  / {
> >>>> @@ -40,7 +42,7 @@
> >>>>
> >>>>         sdio4: sdio@3f1b0000 {
> >>>>                 max-frequency = <48000000>;
> >>>> -               cd-gpios = <&gpio 14 0>;
> >>>> +               cd-gpios = <&gpio 14 GPIO_ACTIVE_LOW>;
> >>>>                 status = "okay";
> >>>>         };
> >>>>  };
> >>>> --
> >>>> 1.8.0.1
> >>>>
> >>> Tim,
> >>>  Does bcm11351-brt not also suffer from the same bug? If it does can
> >>> you pls update the patch to also fix it?
> >>>
> >>>  Thanks,
> >>>    csd
> >>
> >> The BRT and AP boards are similar so it may have the same problem but
> >> I don't have a BRT and wouldn't be able to test any changes to its DTS
> >> file.
> >>
> >> -Tim
> >
> > [sorry for the resend for those that get it twice]
> > Agreed - it's time that dts file go away. In this case:
> > Acked-by: Christian Daudt <bcm@fixthebug.org>
> >
> > Olof - can you pls pull in this patch. This is the bugfix that was
> > discussed in irc earlier today.
> >
> >  thanks,
> >    csd
> 
> Christian,
> 
> I'm not sure Olof saw your reply.  Olof and Kevin are now on CC.

Nope, applied now. Had to touch it up a bit since we're missing some of the
patches that this was based on for 3.14, but the cd-gpios property is fixed.


-Olof
