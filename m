Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbaAHTsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:48:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:19511 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaAHTse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:48:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,626,1384329600"; 
   d="scan'208";a="402102541"
Date: Wed, 8 Jan 2014 11:53:34 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>, sarah.a.sharp@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jianqian <jianqiang.tang@intel.com>
Subject: Re: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()
Message-ID: <20140108195334.GB27907@psi-dev26.jf.intel.com>
References: <20140108014550.GA7823@kroah.com>
 <Pine.LNX.4.44L0.1401081046300.1659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401081046300.1659-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 10:48:06AM -0500, Alan Stern wrote:
> On Tue, 7 Jan 2014, Greg KH wrote:
> 
> > On Tue, Jan 07, 2014 at 05:44:26PM -0800, David Cohen wrote:
> > > From: jianqian <jianqiang.tang@intel.com>
> > > 
> > > There is a possible kernel panic faced on xhci_suspend().
> > > Due to kernel modified the hub autosupend_delay to 0s, after usb1 root
> > > hub finishes initialization, it will trigger runtime_suspend and then
> > > it will trigger xhci runtime suspend. But at that time, if
> > > xhci->shared_hcd is still doing initialization, it is possible to face
> > > null pointer kernel panic in xhci_suspend() function.
> > > 
> > > This patch checks if xhci->shared_hcd is null to avoid panic.
> > 
> > That sounds like this is a race that should be fixed properly, not just
> > papered over, right?
> 
> That was my reaction too.  The best way to solve the problem is to 
> prevent the USB-2 root hub from suspending until after the USB-3 root 
> hub has been registered.

That makes sense. Thanks for the feedback.
I'll check for a new approach.

Br, David Cohen

> 
> Alan Stern
