Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3CSP1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:27:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57993 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756604Ab3CSP1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:27:15 -0400
Date: Tue, 19 Mar 2013 11:27:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ben Hutchings <ben@decadent.org.uk>
cc: stable@vger.kernel.org, <akpm@linux-foundation.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 45/82] USB: EHCI: dont check DMA values in QH overlays
In-Reply-To: <1363662540.3937.366.camel@deadeye.wl.decadent.org.uk>
Message-ID: <Pine.LNX.4.44L0.1303191125100.15684-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Ben Hutchings wrote:

> On Mon, 2013-03-18 at 04:22 +0000, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > commit feca7746d5d9e84b105a613b7f3b6ad00d327372 upstream.
> > 
> > This patch (as1661) fixes a rather obscure bug in ehci-hcd.  In a
> > couple of places, the driver compares the DMA address stored in a QH's
> > overlay region with the address of a particular qTD, in order to see
> > whether that qTD is the one currently being processed by the hardware.
> > (If it is then the status in the QH's overlay region is more
> > up-to-date than the status in the qTD, and if it isn't then the
> > overlay's value needs to be adjusted when the QH is added back to the
> > active schedule.)
> > 
> > However, DMA address in the overlay region isn't always valid.  It
> > sometimes will contain a stale value, which may happen by coincidence
> > to be equal to a qTD's DMA address.  Instead of checking the DMA
> > address, we should check whether the overlay region is active and
> > valid.  The patch tests the ACTIVE bit in the overlay, and clears this
> > bit when the overlay becomes invalid (which happens when the
> > currently-executing URB is unlinked).
> > 
> > This is the second part of a fix for the regression reported at:
> > 
> > 	https://bugs.launchpad.net/bugs/1088733
> 
> Alan, the first part (commit 6402c796d3b4 aka as1660) didn't apply and I
> couldn't see how to adapt it for 3.2.  Does this second part have any
> value without the first?  Or, if you could provide a backport of the
> first part, that would be very much appreciated.

Without the first part, the second part can actually be dangerous.  
Under the circumstances, I think it is best to apply neither.

Alan Stern

