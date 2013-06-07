Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3FGFht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:37:49 -0400
Received: from 1wt.eu ([62.212.114.60]:36093 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3FGFhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:37:48 -0400
Date: Fri, 7 Jun 2013 07:37:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 061/184] PCI/PM: Clean up PME state when removing a device
Message-ID: <20130607053740.GG14633@1wt.eu>
References: <20130604172132.836205446@1wt.eu> <1370579036.4021.68.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370579036.4021.68.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:23:56AM +0100, Ben Hutchings wrote:
> On Tue, 2013-06-04 at 19:22 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > 
> > commit 249bfb83cf8ba658955f0245ac3981d941f746ee upstream.
> > 
> > Devices are added to pci_pme_list when drivers use pci_enable_wake()
> > or pci_wake_from_d3(), but they aren't removed from the list unless
> > the driver explicitly disables wakeup.  Many drivers never disable
> > wakeup, so their devices remain on the list even after they are
> > removed, e.g., via hotplug.  A subsequent PME poll will oops when
> > it tries to touch the device.
> > 
> > This patch disables PME# on a device before removing it, which removes
> > the device from pci_pme_list.  This is safe even if the device never
> > had PME# enabled.
> 
> There's no such list in 2.6.32, so I don't think this is needed.

Dropped, thanks !

Willy

