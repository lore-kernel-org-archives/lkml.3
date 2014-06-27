Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaF0Uqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:46:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaF0Uqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:46:30 -0400
Date: Fri, 27 Jun 2014 13:50:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
Message-ID: <20140627205039.GA5552@kroah.com>
References: <20140627192238.GA7646@kroah.com>
 <Pine.LNX.4.44L0.1406271606000.875-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1406271606000.875-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:11:35PM -0400, Alan Stern wrote:
> On Fri, 27 Jun 2014, Greg Kroah-Hartman wrote:
> 
> > > One side point: The patch changes the string displayed for the 
> > > power/runtime_status attribute file when disable_depth > 0.  Instead of 
> > > "unsupported", it will now say "disabled".  The attribute will contain 
> > > "not supported" when the new flag is set.
> > > 
> > > Is this acceptable?
> > 
> > Why change the "unsupported" string?  Can't we just leave that one
> > alone?  I'd prefer to not break userspace tools...
> 
> I changed it because it's wrong.  disable_depth > 0 means that runtime 
> PM has temporarily been disabled, or was never enabled in the first 
> place.  It doesn't mean that runtime PM is unsupported.
> 
> In fact, the word "unsupported" is ambiguous.  Does it mean unsupported 
> by the hardware or unsupported by the kernel?  The hardware can't 
> change, but the kernel can be altered by loading a module.
> 
> If that change is too intrusive, I can remove it from the patch.

Do you know of any tools that actually look at these files?

If there isn't any, then we can try to change it and see who screams :)

greg k-h
