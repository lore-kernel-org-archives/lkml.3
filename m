Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaF3Nes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:34:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55086 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752209AbaF3Ner (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:34:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
Date: Mon, 30 Jun 2014 15:52:40 +0200
Message-ID: <2020781.AOFsAxmkyt@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1406281131360.983-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1406281131360.983-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 28, 2014 11:32:21 AM Alan Stern wrote:
> On Fri, 27 Jun 2014, Greg Kroah-Hartman wrote:
> 
> > On Fri, Jun 27, 2014 at 04:11:35PM -0400, Alan Stern wrote:
> > > On Fri, 27 Jun 2014, Greg Kroah-Hartman wrote:
> > > 
> > > > > One side point: The patch changes the string displayed for the 
> > > > > power/runtime_status attribute file when disable_depth > 0.  Instead of 
> > > > > "unsupported", it will now say "disabled".  The attribute will contain 
> > > > > "not supported" when the new flag is set.
> > > > > 
> > > > > Is this acceptable?
> > > > 
> > > > Why change the "unsupported" string?  Can't we just leave that one
> > > > alone?  I'd prefer to not break userspace tools...
> > > 
> > > I changed it because it's wrong.  disable_depth > 0 means that runtime 
> > > PM has temporarily been disabled, or was never enabled in the first 
> > > place.  It doesn't mean that runtime PM is unsupported.
> > > 
> > > In fact, the word "unsupported" is ambiguous.  Does it mean unsupported 
> > > by the hardware or unsupported by the kernel?  The hardware can't 
> > > change, but the kernel can be altered by loading a module.
> > > 
> > > If that change is too intrusive, I can remove it from the patch.
> > 
> > Do you know of any tools that actually look at these files?
> 
> I don't.  Of course, that doesn't mean much.

The only tool I'm aware of that may be looking at them is powertop, so
if the change doesn't affect powertop adversely, it should be generally
safe.

> > If there isn't any, then we can try to change it and see who screams :)
> 
> It'll be a learning experience...

Yes, it will. :-)

Rafael

