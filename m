Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaARC4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 21:56:11 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33538 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaARC4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 21:56:08 -0500
Date: Fri, 17 Jan 2014 21:56:00 -0500
From: Matt Porter <mporter@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "arm@kernel.org" <arm@kernel.org>, Mark Brown <broonie@kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
Message-ID: <20140118025600.GS31049@beef>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
 <1387592016-13740-1-git-send-email-syin@broadcom.com>
 <1387592016-13740-4-git-send-email-syin@broadcom.com>
 <CACRpkdaPZrR=kEknr3YKDWLd_E+o22Yn19ei7iT6cdbYdbeZ2w@mail.gmail.com>
 <52D98B99.5050604@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D98B99.5050604@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 11:59:21AM -0800, Sherman Yin wrote:
> On 14-01-16 05:19 AM, Linus Walleij wrote:
> >On Sat, Dec 21, 2013 at 3:13 AM, Sherman Yin <syin@broadcom.com> wrote:
> >
> >'> Adds pinctrl driver for Broadcom Capri (BCM281xx) SoCs.
> >>
> >>Signed-off-by: Sherman Yin <syin@broadcom.com>
> >>Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> >>Reviewed-by: Matt Porter <matt.porter@linaro.org>
> >>---
> >>v4: - PINCTRL selected in Kconfig, PINCTRL_CAPRI selected in bcm_defconfig
> >>     - make use of regmap
> >>     - change CAPRI_PIN_UPDATE from macro to inline function.
> >>     - Handle pull-up strength arg in Ohm instead of enum
> >
> >Patch applied. It is really good now! It's late before the merge
> >window, but you've done a tremendous work on this driver and
> >I don't want to delay its deployment further.
> 
> Great, thanks for the support and reviews!

Very nice! Now after having completely missing something fundamental on
my reviews, I feel compelled to bring it up at the 11^H^H12th hour.

That is, this is the *only* BCM281xx driver to be named Capri, both in
the filename and driver code, but also in the binding compatible. We
didn't do that on anything else that's gone upstream to date. This
really introduces an unfortunate inconsistency as it obscures which
SoC family this binding and driver belong with.

I wonder if Linus would accept a rename at this point (too late for 3.14
presumably, but for 3.15) of s/capri/bcm281xx throughout, bcm11351 for
the compatible string, as we have for the machine compatible, and also
BCM281XX for the Kconfig option. If not, I'll survive, but it pains me
to see one thing completely different out of this entire family. If
nothing else, it would be great to address the compatible string before
this hits the 3.14 release.

Linus?

-Matt
