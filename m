Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3BGIae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:30:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3BGIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:30:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 13/14] ARM: ux500: enable AB8500 GPIO for HREF
Date: Thu, 7 Feb 2013 08:30:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        arm@kernel.org, Linus Walleij <linus.walleij@linaro.org>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com> <1360093715-6348-14-git-send-email-linus.walleij@stericsson.com> <5112F284.3040002@wwwdotorg.org>
In-Reply-To: <5112F284.3040002@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302070830.22719.arnd@arndb.de>
X-Provags-ID: V02:K0:TbxSzofnGgWn8vglhN2Pmf+1pks/ueBzQgM3HdN4Ib6
 gHfw3Ue3Rfe7SJ2fcFRA3M1BxDBBKuNqyE9s4j+vAYFRSfSUL7
 nxll9SP1sZOrMIN29yADGaooYFJ/MbyF3n+ODR/DPeVc0kzBe6
 IJ2pNZHeKzNcj/24WhAyG37L4ye+8qhWivS5MX6uc4ZBLIX9jN
 SpykHfkPoaLWG5oNmkublZcobObOrcs5yXvWScMIrENcwo1ebU
 Dtp4ebDH5fWUZCEJ+YfcmizuNhT8zw6Pki1nrp/iAuuvXIJth8
 uD0UPHN7CB0UgrZdP1R2ot2LXY6SS2ngr9kaKnZLxpA3C/wWHk
 zPPAOh0Kbct+ZFt7zWqg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Stephen Warren wrote:
> On 02/05/2013 12:48 PM, Linus Walleij wrote:
> > From: Lee Jones <lee.jones@linaro.org>
> > 
> > The AB8500 GPIO driver has been un-BROKEN and rewritten as a pinctrl
> > driver. Now that it's back in use, let's ensure that it's available
> > when booting HREF with Device Tree enabled.
> 
> > diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts
> 
> >       soc-u9500 {
> > +             prcmu@80157000 {
> > +                     ab8500@5 {
> > +                             ab8500-gpio {
> > +                                     compatible = "stericsson,ab8500-gpio";
> 
> The MFDs I've looked at (which admittedly might not be that many) all
> have the top-level chip described in device tree, but not all the
> component sub-devices, since they're all a static part of the top-level
> chip. Instead, the top-level MFD instantiates all the sub-devices
> itself. I'm curious why this MFD device works differently - do many work
> like this?

I think in general, describing only the top level in DT is preferred.
However, that does not work if you have devices outside of the MFD
refer to devices inside of it, such as GPIO, clocks or interrupts:

In order to connect a button or an LED to this GPIO controller
in DT, you need to have a node you can refer to that follows the
GPIO binding. Putting all of that into the top-level device
would get messy here.

	Arnd
