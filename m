Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3JHNZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:25:12 -0400
Received: from mail.abilis.ch ([195.70.19.74]:16807 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab3JHNZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:25:08 -0400
X-Greylist: delayed 3775 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 09:25:06 EDT
Date: Tue, 8 Oct 2013 14:21:45 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
Message-ID: <20131008122145.GA21985@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
 <CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com>
 <20130805115118.GF20936@ab42.lan>
 <CACRpkdaXqHHF5oDsWSCyhzUOurrxfLhS40=csGJFT8fK4WkA4A@mail.gmail.com>
 <20130821155751.GB3046@ab42.lan>
 <5216704F.60007@wwwdotorg.org>
 <20130828144736.GA7066@ab42.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828144736.GA7066@ab42.lan>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 04:47:36PM +0200, Christian Ruppert wrote:
> On Thu, Aug 22, 2013 at 02:10:55PM -0600, Stephen Warren wrote:
> [...]
> > Pin groups are supposed to be something that represents some property of
> > the pinctrl HW itself. So, if you have register "X" bits 3-0 that define
> > the mux function for pins 8, 9, 10, and 11, then there really is a pin
> > group that exists in HW, and that pin group will still exist with that
> > same definition no matter what SoC you put the pinctrl HW into. If this
> > changes, it's not the same pinctrl HW module.
> 
> In TB10x, every function can be activated on exactly one pin group, and
> Documentation/pinctrl.txt says "If only one possible group of pins is
> available for the function, no group name need to be supplied.".
> 
> Maybe the answer to our concrete question of the tb10x driver is thus
> renaming the pingrp device tree property of the original patch into
> something like function (by which a pin group can be implied)?
> 
> For example:
> iomux: iomux@FF10601c {
>         compatible = "abilis,tb10x-iomux";
>         reg = <0xFF10601c 0x4>;
>         pctl_gpio_a: pctl-gpio-a {
>                 abilis,function = "gpioa";
>         };
>         pctl_uart0: pctl-uart0 {
>                 abilis,function = "uart0";
>         };
> };
> 
> What do you think?

There doesn't seem to be any opposition to this proposal so please find
a revised patch set in the follow up.

Greetings,
  Christian
