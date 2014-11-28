Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaK1Pa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:30:56 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:39155 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaK1Pay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:30:54 -0500
Date: Fri, 28 Nov 2014 15:30:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        arm@kernel.org, Mike Turquette <mturquette@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>, linux-kernel@vger.kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v2 RESEND 1/2] ARM: vexpress: Remove non-DT code
Message-ID: <20141128153026.GU3836@n2100.arm.linux.org.uk>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
 <201411281608.34978.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201411281608.34978.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 04:08:34PM +0100, Arnd Bergmann wrote:
> On Tuesday 25 November 2014, Pawel Moll wrote:
> > Now, with the CLCD DT support available, there is no
> > more reason to keep the non-DT support for V2P-CA9.
> > 
> > Removed, together with "some" supporting code. It was
> > necessary to make PLAT_VERSATILE_SCHED_CLOCK optional
> > and selected by the machines still interested in it.
> > 
> > Acked-by: Mike Turquette <mturquette@linaro.org>
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > ---
> > Changes since v1:
> > 
> > - Removed MFD and power/reset changes from the patch;
> >   will be posted separately after this is merged.
> 
> Applied to next/cleanup, thanks!

Shame it doesn't work in DT mode though.  Compare these boot logs:

  http://www.arm.linux.org.uk/developer/build/result.php?type=boot&idx=3068

with:

  http://www.arm.linux.org.uk/developer/build/result.php?type=boot&idx=3071

and spot the difference.

The biggest problem is the nonfunctional MMC interface:

mmci-pl18x 10005000.mmci: no support for card's volts
mmc0: error -22 whilst initialising SD card

which, as the rootfs is on the SD card, is pretty fatal.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
