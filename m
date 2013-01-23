Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3AWBF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:05:57 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:53933 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3AWBFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:05:53 -0500
Date: Tue, 22 Jan 2013 17:05:50 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / PM: Expose lists of device power resources to
 user space
Message-ID: <20130123010550.GB2024@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <4110339.gOkm8VAsyn@vostro.rjw.lan>
 <4989050.jK98Xm5BOW@vostro.rjw.lan>
 <3211997.SUlOUD0HDl@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3211997.SUlOUD0HDl@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 01:28:40AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, January 23, 2013 01:17:47 AM Rafael J. Wysocki wrote:
> > On Wednesday, January 23, 2013 01:08:54 AM Rafael J. Wysocki wrote:
> > > On Tuesday, January 22, 2013 03:56:24 PM Greg Kroah-Hartman wrote:
> > > > On Tue, Jan 22, 2013 at 03:28:23AM +0100, Rafael J. Wysocki wrote:
> > 
> > [...]
> > 
> > > > Oh, and same question about racing userspace, you will have problems
> > > > here in that the symlinks will be showing up after the device is
> > > > created.  Perhaps, to make the whole thing easier, you just change the
> > > > acpi core code to hold off on the notification until you get all of
> > > > these links and files set up and then tell userspace.  That's probably
> > > > an easier fix.
> > > 
> > > I suppose so.
> > > 
> > > How can I do that?
> > 
> > Should I set dev->kobj.uevent_suppress before calling device_register() and
> > then clear it and call the kobject_uevent(&dev->kobj, KOBJ_ADD) from the ACPI
> > core after device_register() has returned and the files have been created?
> 
> I suppose along the lines of how firmware_class.c uses uevent_suppress?
> 
> Is there any safe mechanism for adding/removing sysfs attributes after
> kobject_uevent(&dev->kobj, KOBJ_ADD) has been called for the given device?

Not really.  There is the KBOJ_CHANGE event that some subsystems use
(hey look, ACPI already uses it), but that's usually used to tell
userspace that the kobject has somehow "changed" status, just adding the
initial files to it seems like a gratuitous "change", right?

thanks,

greg k-h
