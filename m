Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3J0N5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:57:30 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58874 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3J0N53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:57:29 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv6 1/3] Input: twl4030-pwrbutton - add device tree support
To: Sebastian Reichel <sre@debian.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
In-Reply-To: <20131025234031.GC8657@earth.universe>
References: <1382626126-12565-1-git-send-email-sre@debian.org> <1382626126-12565-2-git-send-email-sre@debian.org> <20131025190904.3EE93C403B8@trevor.secretlab.ca> <20131025234031.GC8657@earth.universe>
Date: Sun, 27 Oct 2013 13:57:25 +0000
Message-Id: <20131027135725.BF367C4039D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013 01:40:31 +0200, Sebastian Reichel <sre@debian.org> wrote:
> On Fri, Oct 25, 2013 at 08:09:04PM +0100, Grant Likely wrote:
> > On Thu, 24 Oct 2013 16:48:44 +0200, Sebastian Reichel <sre@debian.org> wrote:
> > > Add device tree support for twl4030 power button driver.
> > 
> > The above commit text is insufficient. There are changes in the patch
> > that aren't described here and have nothing to do with device tree
> > bindings.
> 
> I will update the description in PATCHv7.
> 
> > [...]
> > > +++ b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
> > 
> > Can all of the TWL or TWL4030 funciton bindings be collected into a
> > single file please? It is a single device after all. All of it should be
> > in bindings/mfd/twl-family.txt
> 
> I guess this should be done in another patch? There's also a typo in
> twl-family.txt's filename. My suggestion is to leave the patchset in
> its current state. I will create another patch, which combines all
> the twl4030 bindings descriptions into one file.

Yes, that is fine.

> 
> > [...]
> > > +- interrupt: should be one of the following
> > 
> > Spelling: s/interrupt/interrupts/
> 
> fixed.
> 
> > [...]
> > >  static struct platform_driver twl4030_pwrbutton_driver = {
> > > +	.probe		= twl4030_pwrbutton_probe,
> > >  	.remove		= __exit_p(twl4030_pwrbutton_remove),
> > 
> > Remove the __exit_p() wrapper. __exit is for module exit functions, not
> > remove hooks (I know, that's not actually this patch, but the code is
> > definitely wrong here).
> 
> On of the following patches converts the driver to devm, which
> results in complete removal of the twl4030_pwrbutton_remove
> function.

Okay.

g.
