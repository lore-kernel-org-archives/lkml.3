Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946428Ab3BHMj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:39:28 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34250 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946405Ab3BHMj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:39:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jiang Liu <liuj97@gmail.com>, Toshi Kani <toshi.kani@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] ACPI / scan: Make container driver use struct acpi_scan_handler
Date: Fri, 08 Feb 2013 13:45:46 +0100
Message-ID: <6971980.h8IEYnHJo0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQW6BDpSjNjbinHEkpud2QqQOqskkXca6z+Fq0fo+=pKyQ@mail.gmail.com>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <6697533.ch61jtPBiZ@vostro.rjw.lan> <CAE9FiQW6BDpSjNjbinHEkpud2QqQOqskkXca6z+Fq0fo+=pKyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2013 07:32:22 PM Yinghai Lu wrote:
> On Thu, Feb 7, 2013 at 4:27 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Make the ACPI container driver use struct acpi_scan_handler for
> > representing the object used to initialize ACPI containers and remove
> > the ACPI driver structure used previously and the data structures
> > created by it, since in fact they were not used for any purpose.
> >
> > This simplifies the code and reduces the kernel's memory footprint by
> > avoiding the registration of a struct device_driver object with the
> > driver core and creation of its sysfs directory which is unnecessary.
> >
> > In addition to that, make the namespace walk callback used for
> > installing the notify handlers for ACPI containers more
> > straightforward.
> >
> > This change includes fixes from Toshi Kani.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Yes, container support should be built-in by nature.
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks!

> What is the next?

I've sent a patch for memory hotplug already, but I'm a little concerned about
it, because after my patch users wouldn't have an option to turn memory eject
off (now they can remove the module, which is suboptimal, but at least it kind
kind of works).  So I think there needs to be some sysfs-based switch for that
or something.

> dock?

It is on the radar, but it also is kind of a can of worms. :-)

> Hope someone with access of dock that have pcie devices could help
> sorting it out...

Someone having a system like that told me he was willing to test patches,
but I got distracted by something.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
