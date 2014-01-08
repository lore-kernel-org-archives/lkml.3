Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaAHPsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:48:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59082 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755363AbaAHPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:48:08 -0500
Date: Wed, 8 Jan 2014 10:48:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: David Cohen <david.a.cohen@linux.intel.com>,
        <sarah.a.sharp@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, jianqian <jianqiang.tang@intel.com>
Subject: Re: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()
In-Reply-To: <20140108014550.GA7823@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1401081046300.1659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jan 2014, Greg KH wrote:

> On Tue, Jan 07, 2014 at 05:44:26PM -0800, David Cohen wrote:
> > From: jianqian <jianqiang.tang@intel.com>
> > 
> > There is a possible kernel panic faced on xhci_suspend().
> > Due to kernel modified the hub autosupend_delay to 0s, after usb1 root
> > hub finishes initialization, it will trigger runtime_suspend and then
> > it will trigger xhci runtime suspend. But at that time, if
> > xhci->shared_hcd is still doing initialization, it is possible to face
> > null pointer kernel panic in xhci_suspend() function.
> > 
> > This patch checks if xhci->shared_hcd is null to avoid panic.
> 
> That sounds like this is a race that should be fixed properly, not just
> papered over, right?

That was my reaction too.  The best way to solve the problem is to 
prevent the USB-2 root hub from suspending until after the USB-3 root 
hub has been registered.

Alan Stern

