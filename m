Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaB0PCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:02:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42639 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751966AbaB0PCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:02:08 -0500
Date: Thu, 27 Feb 2014 10:02:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / sleep: New flag to speed up suspend-resume of
 suspended devices
In-Reply-To: <4633671.dBN1DXCk1F@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1402271001190.1150-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Rafael J. Wysocki wrote:

> > If the child knows about the problem beforehand, it can runtime-resume 
> > the parent during its ->suspend.
> 
> Well, it even should do that in those cases.  We may need to deal with children
> that don't do that, though.
> 
> > > Well, if power.fast_suspend set guarantees that ->suspend_late, ->suspend_noirq,
> > > ->resume_noirq, and ->resume_early will be skipped for a device, then we may
> > > restrict setting it for devices whose children have it set (or that have no
> > > children).  Initially, that will be equivalent to setting it for leaf devices
> > > only, but it might be extended over time in a natural way.
> > 
> > Initially, maybe.
> 
> Of course initially.
> 
> > But it's the wrong approach in general.
> 
> In the long run - I agree.
> 
> > The right approach is to restrict setting fast_suspend for devices whose
> > children don't mind their parent being suspended when their resume callbacks 
> > run -- not for devices whose children also have fast_suspend set.
> 
> I agree, but we need to know which children are OK with the parent being
> suspended.  Having fast_suspend set is a good indication of that. :-)
> 
> Of course, we may introduce a separate flag for that just fine if you prefer.
> 
> > That's the point I've been trying to express all along.
> 
> I see.

Okay.  I'll wait to see the next version.

Alan Stern

