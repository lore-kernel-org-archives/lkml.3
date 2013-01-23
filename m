Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3AWAWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:22:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50929 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab3AWAWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:22:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / PM: Expose lists of device power resources to user space
Date: Wed, 23 Jan 2013 01:28:40 +0100
Message-ID: <3211997.SUlOUD0HDl@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <4989050.jK98Xm5BOW@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <4110339.gOkm8VAsyn@vostro.rjw.lan> <4989050.jK98Xm5BOW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 23, 2013 01:17:47 AM Rafael J. Wysocki wrote:
> On Wednesday, January 23, 2013 01:08:54 AM Rafael J. Wysocki wrote:
> > On Tuesday, January 22, 2013 03:56:24 PM Greg Kroah-Hartman wrote:
> > > On Tue, Jan 22, 2013 at 03:28:23AM +0100, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > > Oh, and same question about racing userspace, you will have problems
> > > here in that the symlinks will be showing up after the device is
> > > created.  Perhaps, to make the whole thing easier, you just change the
> > > acpi core code to hold off on the notification until you get all of
> > > these links and files set up and then tell userspace.  That's probably
> > > an easier fix.
> > 
> > I suppose so.
> > 
> > How can I do that?
> 
> Should I set dev->kobj.uevent_suppress before calling device_register() and
> then clear it and call the kobject_uevent(&dev->kobj, KOBJ_ADD) from the ACPI
> core after device_register() has returned and the files have been created?

I suppose along the lines of how firmware_class.c uses uevent_suppress?

Is there any safe mechanism for adding/removing sysfs attributes after
kobject_uevent(&dev->kobj, KOBJ_ADD) has been called for the given device?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
