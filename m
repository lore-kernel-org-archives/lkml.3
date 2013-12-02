Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3LBLrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:47:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43811 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3LBLrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:47:23 -0500
Date: Mon, 2 Dec 2013 11:46:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: linus.walleij@linaro.org, arnd@arndb.de, monstr@monstr.eu, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM:INTEGRATOR: Default enable ARM_PATCH_PHYS_VIRT,
	AUTO_ZRELADDR
Message-ID: <20131202114638.GH16735@n2100.arm.linux.org.uk>
References: <1385983731-13196-1-git-send-email-panchaxari.prasannamurthy@linaro.org> <1385983731-13196-2-git-send-email-panchaxari.prasannamurthy@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385983731-13196-2-git-send-email-panchaxari.prasannamurthy@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 04:58:51PM +0530, panchaxari wrote:
> ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR has been enabled as default configs
> to integrator platform.
> 
> Introduction of PHYS_VIRT config as default would enable phy-to-virt and
> virt-to-phy translation function at boot and module loading time
> and enforce dynamic reallocation of memory. AUTO_ZRELADDR config would
> enable calculation of kernel load address at run time.
> 
> PHYS_VIRT config is mutually exclusive to XIP_KERNEL, XIP_KERNEL is used in
> systems with NOR flash devices, and ZRELADDR config is mutually exclusive
> to ZBOOT_ROM.
> 
> Requesting maintainers of Integrator platform to evaluate the changes on the
> board and comment, as I dont have the board for testing and also requesting
> an ACK.

This is _exactly_ the kind of patches I don't want to see - people
running around changing platforms with no way to test them.  I spent
most of last week sorting out the fallout from the "single zImage"
project breaking the Versatile and footbridge platforms, and I've
decided that this kind of thing has to stop.

We can't have arch/arm living in a constant cycle of total brokenness
with nothing being stable.  It was a hell of a lot better in terms of
not being broken when we didn't have this silly single zImage project.

If you want to do such work, send the patches with "[CFT]" in the
subject line - call for testing.

What that means is "this patch is experimental, we don't know if it
works, and we'd like someone to test it." and more importantly "It's
not for merging yet."

If no one steps up to test it, then it should *not* be merged, because
you're potentially de-stablising an existing platform.  Yes, I know
that will make things harder to get into the kernel, but that's the way
it _should_ be if you're going to be causing pain to people.

Frankly, I suspect most "users" just don't touch the mainline kernel
anymore - they all rely on (eg) debian people to maintain an effective
forked mainline kernel separately which has all our fsckups fixed.
Hence why we don't get to hear about this stuff breaking.
