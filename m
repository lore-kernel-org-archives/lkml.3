Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaF0ULh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:11:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37460 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750831AbaF0ULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:11:36 -0400
Date: Fri, 27 Jun 2014 16:11:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
In-Reply-To: <20140627192238.GA7646@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1406271606000.875-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014, Greg Kroah-Hartman wrote:

> > One side point: The patch changes the string displayed for the 
> > power/runtime_status attribute file when disable_depth > 0.  Instead of 
> > "unsupported", it will now say "disabled".  The attribute will contain 
> > "not supported" when the new flag is set.
> > 
> > Is this acceptable?
> 
> Why change the "unsupported" string?  Can't we just leave that one
> alone?  I'd prefer to not break userspace tools...

I changed it because it's wrong.  disable_depth > 0 means that runtime 
PM has temporarily been disabled, or was never enabled in the first 
place.  It doesn't mean that runtime PM is unsupported.

In fact, the word "unsupported" is ambiguous.  Does it mean unsupported 
by the hardware or unsupported by the kernel?  The hardware can't 
change, but the kernel can be altered by loading a module.

If that change is too intrusive, I can remove it from the patch.

Alan Stern

