Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaACAED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:04:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:25416 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaACAEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:04:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,594,1384329600"; 
   d="scan'208";a="460950961"
Date: Thu, 2 Jan 2014 16:03:34 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis.turischev@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Oliver Neukum <oneukum@suse.de>,
        dashing.meng@gmail.com, Niklas Schnelle <niklas@komani.de>,
        Giorgos <ganastasiouGR@gmail.com>, art1@vhex.net
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on
 shutdown
Message-ID: <20140103000334.GE9621@xanatos>
References: <52B31EDA.60908@compulab.co.il>
 <52B327D5.3080805@compulab.co.il>
 <20131219182110.GC3573@xanatos>
 <52B41EC7.1070704@compulab.co.il>
 <20131220234547.GC2835@xanatos>
 <52B69925.8030409@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B69925.8030409@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 09:47:49AM +0200, Denis Turischev wrote:
> On 12/21/2013 01:45 AM, Sarah Sharp wrote:
> > On Fri, Dec 20, 2013 at 12:41:11PM +0200, Denis Turischev wrote:
> >>> Also, which kernel are you experiencing this issue on?  In 3.12, I
> >>> queued a separate patch to deal with spurious reboot issues on Lynx
> >>> Point:
> >>>
> >>> commit 638298dc66ea36623dbc2757a24fc2c4ab41b016
> >> Sorry, I indeed tested not on the latest kernel version, Ubuntu 3.13-rc3 has this patch and it works
> >> for me.
> > 
> > What does "Ubuntu 3.13-rc3" mean?  Where did you get your kernel from?
> Latest Ubuntu development kernel based on mainline 3.13-rc3.
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.13-rc3-trusty/
> > 
> > Also, do you have an HP system, or is this a different vendor?
> No, it's not HP system, it's Compulab's IntensePC-2 with Phoenix BIOS.

Ok, that's a bit of an issue then.  Your system needs the quirk
introduced by commit 638298dc66ea36623dbc2757a24fc2c4ab41b016 "xhci: Fix
spurious wakeups after S5 on Haswell".  That went into 3.12-rc3.
However, in 3.13-rc6, commit 6962d914f317b119e0db7189199b21ec77a4b3e0
"xhci: Limit the spurious wakeup fix only to HP machines" limited the
quirk to only HP systems.

That means your system worked fine in 3.13-rc3 (when the quirk was
applied broadly), but won't work for 3.13-rc6 (when the quirk was
narrowed to HP machines).  So we need the quirk to apply to your systems
as well.

ISTR that the other folks on Cc (Meng, Niklas, Giorgos, and Art) all had
systems that broke when commit 638298dc66ea36623dbc2757a24fc2c4ab41b016
was introduced.  For those systems, what vendor was the system, and what
BIOS was it running?

Takashi, did the HP systems that needed the quirk have a Phoenix BIOS?

Denis, do all of Compulab's Haswell systems reboot on shutdown?  Are
they all running a Phoenix BIOS?  Can you send me the output of `sudo
lspci -vvv -s` for the xHCI host?

Basically, I'm trying to find a common variable to key off.  I suspect
BIOS vendor is probably the right thing, instead of system vendor.

Sarah Sharp
