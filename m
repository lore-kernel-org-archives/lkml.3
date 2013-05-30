Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3E3SUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:20:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:62345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab3E3SUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:20:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="322070561"
Date: Thu, 30 May 2013 11:20:09 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: xhci: rename ambiguous named XHCI_NEC_HOST to
 XHCI_NEC_SHOW_FW
Message-ID: <20130530182009.GB8006@xanatos>
References: <1369862073-3685-1-git-send-email-holler@ahsoftware.de>
 <20130529222500.GC7151@xanatos>
 <51A6D2A2.30302@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A6D2A2.30302@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 06:16:34AM +0200, Alexander Holler wrote:
> Am 30.05.2013 00:25, schrieb Sarah Sharp:
> > 
> > On Wed, May 29, 2013 at 11:14:32PM +0200, Alexander Holler wrote:
> >> Current Renesas Electronics XHCI hosts (which were formerly NEC)
> >> do support the same vendor command to show the firmware. Rename the
> >> ambigious named define XHCI_NEC_HOST to XHCI_NEC_SHOW_FW because it's
> >> only used to display the firmware version. Besides that, change the
> >> output "... NEC firmware version x.y" to "... firmware version x.y"
> >> to not confuse owners of Renesas USB hosts.
> >>
> >> (so only cosmetic, no functional changes)
> > 
> > I'm actually inclined to say you should just rip out the firmware
> > version code entirely.  I haven't needed to use it for years, and if
> > Renesas changed their vendor command set, I would rather not submit
> > random commands to the host.
> > 
> > So, can you redo this patch to just rip out XHCI_NEC_HOST and everything
> > that uses it?
> 
> Hmm, I find the firmware version rather informational and would even
> display it unconditionally (instead of with xhci_debug). It prevents the
> need to boot Windows to checkout if the latest version is installed,
> especially if someone is hunting a bug.

Right, but we need to stop sending commands to Renesas hosts that don't
support this command.  We don't know what that command does in the hosts
that don't support the firmware version command.  For all we know, we
could be setting the host into a debugging mode, or asking it to only
report USB 2.0 device connects, or other things that I can't imagine.

The point is that unless Renesas tells us how to know if a host
supports the firmware fetch vendor command, we should stop issuing that
command to the host.  I think my contacts at Renesas have moved onto
other jobs, but maybe you know someone there?

> I just dont't like the name, because e.g. in my case, it made me to have
> a deeper look at what that quirk does, because I had the hope it might
> solve a problem. Therefor I think it's useful to rename it.

I understand.  If the command worked fine on all Renesas hosts, I would
be fine with renaming it and printing it with dev_info instead of
xhci_dbg.  However, since some Renesas hosts don't support the command,
I'm concerned we may be forced to rip out the code.  If you don't do it,
I will have to.

Sarah Sharp
