Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3BQOBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 09:01:32 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38993 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129Ab3BQOBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 09:01:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: linux-next: build failure after merge of the xen-two tree
Date: Sun, 17 Feb 2013 15:08:02 +0100
Message-ID: <4696812.SKkpQQd9iW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353FCCAC@SHSMSX101.ccr.corp.intel.com>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au> <11850955.SHqxVBsJqI@vostro.rjw.lan> <DE8DF0795D48FD4CA783C40EC82923353FCCAC@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 17, 2013 07:31:37 AM Liu, Jinsong wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, February 16, 2013 01:52:00 AM Stephen Rothwell wrote:
> >> Hi Rafael,
> > 
> > Hi,
> > 
> >> On Fri, 15 Feb 2013 15:53:34 +0100 "Rafael J. Wysocki" <rjw@sisk.pl>
> >> wrote: 
> >>> 
> >>> On Saturday, February 16, 2013 12:50:14 AM Stephen Rothwell wrote:
> >>>> 
> >>>> On Fri, 15 Feb 2013 08:26:24 -0500 Konrad Rzeszutek Wilk
> >>>> <konrad.wilk@oracle.com> wrote: 
> >>>>> 
> >>>>> Thank you. I keep on forgetting - but would it be OK for me to
> >>>>> take this patch in my tree? Or should I not since this is a new
> >>>>> functionality that Rafael is going to introduce in v3.9?
> >>>> 
> >>>> It is an API change in the pm tree that is not yet in Linus' tree.
> >>>> 
> >>>>> And if so, perhaps I should tack it on in my tree, once Rafael
> >>>>> does a git pull to Linus? Or just point Linus to this git commit?
> >>>> 
> >>>> You should point Linus at this patch if the pm tree is merged
> >>>> first, or 
> >>>> Rafael should do the same if the reverse happens.
> >>> 
> >>> Alternatively, Konrad can pull the acpi-scan branch containing the
> >>> changes in question from my tree into his tree and rebase the new
> >>> material on top of that.
> >> 
> >> Or pull the acpi-scan branch into his tree and use my conflict
> >> resolution in the resulting merge thus requiring no rebasing. 
> >> However, Linus likes to see such interactions, so it can be left up
> >> to when the latter of the two tress is merged by Linus.
> > 
> > Well, I'm afraid this won't be sufficient this time, because of this
> > commit in my tree (which is not on the acpi-scan branch):
> > 
> > commit 3757b94802fb65d8f696597a74053cf21738da0b
> > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Date:   Wed Feb 13 14:36:47 2013 +0100
> > 
> >     ACPI / hotplug: Fix concurrency issues and memory leaks
> > 
> > after which acpi_bus_scan() and acpi_bus_trim() have to be run under
> > acpi_scan_lock (new in my tree as well).
> 
> Yes, we noticed that and only need minor updates at xen side, will send out
> 2 xen patches later accordingly, for cleanup and adding lock.

Thanks, but those new changes will only make sense after merging the Xen tree
with the PM tree.  Why don't we queue them up for merging later after both
the Xen and PM trees have been pulled from?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
