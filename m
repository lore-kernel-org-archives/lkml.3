Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3CDOmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:42:55 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:37573 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab3CDOmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:42:53 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [Resend][PATCH] ACPI / PM: Do not power manage devices in unknown initial states
Date: Mon, 04 Mar 2013 15:37:18 +0100
Message-ID: <123861787.JLtSYCl165@al>
User-Agent: KMail/4.10 (Linux/3.8.0-2-custom; KDE/4.10.0; x86_64; ; )
In-Reply-To: <6427459.8Ia2IB77g6@vostro.rjw.lan>
References: <3676077.i6vcpp7Nrn@vostro.rjw.lan> <2135454.ENo8eA9AXp@al> <6427459.8Ia2IB77g6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2013 22:44:55 Rafael J. Wysocki wrote:
> On Friday, February 01, 2013 07:23:52 PM Peter Wu wrote:
> > On Thursday 31 January 2013 23:32:40 Rafael J. Wysocki wrote:
> > > In general, for ACPI device power management to work, the initial
> > > power states of devices must be known (otherwise, we wouldn't be able
> > > to keep track of power resources, for example).  Hence, if it is
> > > impossible to determine the initial ACPI power states of some
> > > devices, they can't be regarded as power-manageable using ACPI.
> > >
> > > 
> > >
> > > For this reason, modify acpi_bus_get_power_flags() to clear the
> > > power_manageable flag if acpi_bus_init_power() fails and add some
> > > extra fallback code to acpi_bus_init_power() to cover broken
> > > BIOSes that provide _PS0/_PS3 without _PSC for some devices.
> > >
> > > 
> > >
> > > Verified to work on my HP nx6325 that has this problem.
> > >
> > > 
> > >
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > 
> >
> > Tested-by: Peter Wu <lekensteyn@gmail.com>
> >
> > 
> >
> > I applied it on top of branch linux-next of repo linux-pm.
> >
> > 
> >
> > Fixes the issue I had with bbswitch in Linux 3.8. Can a backport patch be
> > made  available for 3.8?
> 
> Yes, after this commit enters the mainline.  Please ping me some time around
> 3.9-rc1.

Now that this patch has entered 3.9-rc1, can this be backported to the 3.8 
series?

commit b3785492268f9f3cdaa9722facb84b266dcf8bf6
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Fri Feb 1 23:43:02 2013 +0100

Regards,
Peter
