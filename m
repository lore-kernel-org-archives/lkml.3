Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaDRXTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:19:10 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40514 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751691AbaDRXTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:19:08 -0400
Date: Sat, 19 Apr 2014 00:18:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
	populating interrupts
Message-ID: <20140418231817.GJ24070@n2100.arm.linux.org.uk>
References: <20140410213808.GA5990@atomide.com> <20140411092028.GI16119@n2100.arm.linux.org.uk> <20140411183625.GB3673@mithrandir> <20140418213751.GC21823@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418213751.GC21823@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 02:37:51PM -0700, Tony Lindgren wrote:
> * Thierry Reding <thierry.reding@gmail.com> [140411 11:40]:
> > On Fri, Apr 11, 2014 at 10:20:28AM +0100, Russell King - ARM Linux wrote:
> > > So what happens if a device driver probe function:
> > > 
> > > - creates a new platform device
> > > - copies the resources from the original to the new device
> > > - copies the of_node from the original to the new device
> > > - registers the new device
> > > 
> > > Yes, it's broken (because it can result in the same driver being re-probed
> > > by the new device) but we *do* have stuff in the kernel tree which does
> > > this.
> 
> Grr. Care to list some examples? See also if what I'm suggesting below
> if that might work for the cases you're describing.

Until recently, ahci_imx did exactly this, but that's been fixed now
(by reworking ahci into a library.)  I'm not immediately aware of any
other drivers pulling this trick.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
