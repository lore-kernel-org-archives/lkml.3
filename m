Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3GTUc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:32:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56768 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab3GTUcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:32:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, systemd-devel@lists.freedesktop.org
Subject: Re: udev: New default rule for autoloading kernel modules matching CPU modalias
Date: Sat, 20 Jul 2013 22:42:17 +0200
Message-ID: <19098975.zxpI9DIBHH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAPXgP10cU4AVDEi+ninamvfK_HtKghJL-fJX=E-Y9UPJRrtWAQ@mail.gmail.com>
References: <1623844.aKWlCHQqy1@vostro.rjw.lan> <CAPXgP122sX2eMYEhYam5AUaissw1r4g8PuZajSF7J_rVMFv+Ng@mail.gmail.com> <CAPXgP10cU4AVDEi+ninamvfK_HtKghJL-fJX=E-Y9UPJRrtWAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 20, 2013 02:34:58 PM Kay Sievers wrote:
> On Sat, Jul 20, 2013 at 1:47 PM, Kay Sievers <kay@vrfy.org> wrote:
> > On Sat, Jul 20, 2013 at 12:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> >> After a recent change present in 3.11-rc1 there is a driver, called processor,
> >> that can be bound to the CPU devices whose sysfs directories are located under
> >> /sys/devices/system/cpu/.  A side effect of this is that, after the driver has
> >> been bound to those devices, the kernel adds DRIVER=processor to ENV for CPU
> >> uevents and they don't match the default rule for autoloading modules matching
> >> MODALIAS:
> >>
> >> DRIVER!="?*", ENV{MODALIAS}=="?*", IMPORT{builtin}="kmod load $env{MODALIAS}"
> >>
> >> any more.  However, there are some modules whose module aliases match specific
> >> CPU features through the modalias string and those modules should be loaded
> >> automatically if a compatible CPU is present.  Yet, with the processor driver
> >> bound to the CPU devices the above rule is not sufficient for that, so we need
> >> a new default udev rule allowing those modules to be autoloaded even if the
> >> CPU devices have drivers.
> >>
> >> On my test systems I added the following rule for that:
> >>
> >> ACTION="add", SUBSYSTEM=="cpu", ENV{MODALIAS}=="?*", IMPORT{builtin}="kmod load $env{MODALIAS}"
> >>
> >> in a separate file, but I'm not a udev expert, so I guess it may be done in a
> >> better way.
> >>
> >> Can you please consider adding such a rule to the default set of udev rules?
> >
> > The DRIVER!="?*" is an optimization which made a huge difference at
> > the time we called out to /sbin/modprobe from udev rules and all the
> > devices which already had a driver would not cause needless execution
> > of the rather expensive modprobe binary.
> >
> > This obviously can't do the right thing for the completely generic,
> > not bound to a driver-state, CPU modaliases when they have a driver
> > now. :)
> >
> > These days we load the entire kmod modalias database into the udev
> > process, and lookup what we need to load and load the module from
> > within the udev worker process. It could be, that the optimization is
> > not measurable on today's systems, if that's the case I'll remove it,
> > which would be the simplest and most future proof option. Otherwise
> > I'll add the CPU specific rule.
> >
> > I'll find that out and let you know.
> 
> I cannot see any measurable difference here that justifies that
> optimization, so I removed it:
>   http://cgit.freedesktop.org/systemd/systemd/commit/?id=bf7f800f2b3e93ccd1229d4717166f3a4d3af72f

Many thanks!

Rafael

