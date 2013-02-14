Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934974Ab3BNUw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:52:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38198 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934898Ab3BNUw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:52:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and memory leaks
Date: Thu, 14 Feb 2013 21:59:25 +0100
Message-ID: <7482249.JD6lNDApdo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E368CB5D05@ORSMSX101.amr.corp.intel.com>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan> <7010893.9OBeMt5Fzh@vostro.rjw.lan> <94F2FBAB4432B54E8AACC7DFDE6C92E368CB5D05@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 14, 2013 08:45:14 PM Moore, Robert wrote:
> 
> > -----Original Message-----
> > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > Sent: Thursday, February 14, 2013 4:04 AM
> > To: Moore, Robert
> > Cc: Toshi Kani; ACPI Devel Maling List; LKML; Bjorn Helgaas; Jiang Liu;
> > Yinghai Lu; Yasuaki Ishimatsu; Myron Stowe; linux-pci@vger.kernel.org
> > Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and
> > memory leaks
> > 
> > On Thursday, February 14, 2013 02:31:22 AM Moore, Robert wrote:
> > > > > > I thought about that, but actually there's no guarantee that the
> > > > > > handle will be valid after _EJ0 as far as I can say.  So the
> > > > > > race condition is going to be there anyway and using struct
> > > > > > acpi_device just makes it easier to avoid it.
> > > > >
> > > > > In theory, yes, a stale handle could be a problem, if _EJ0
> > > > > performs unload table and if ACPICA frees up its internal data
> > > > > structure pointed by the handle as a result.  But we should not
> > > > > see such issue now since we do not support dynamic ACPI namespace
> > yet.
> > > >
> > > > I'm waiting for information from Bob about that.  If we can assume
> > > > ACPI handles to be always valid, that will simplify things quite a
> > bit.
> > >
> > > If a table is unloaded, all the namespace nodes for that table are
> > > removed from the namespace, and thus any ACPI_HANDLE pointers go stale
> > and invalid.
> > 
> > OK, thanks!
> > 
> > To me this means that we cannot assume a handle to stay valid between a
> > notify handler and acpi_bus_hot_remove_device() run from a workqueue.
> > 
> > Is there a mechanism in ACPICA to ensure that a handle won't become stale
> > while a notify handler is running for it or is the OS responsible for
> > ensuring that
> > _EJ0 won't be run in parallel with notify handlers for device objects
> > being ejected?
> > 
> 
> It is up to the host.

I was afraid that that might be the case. :-)

So far the (Linux) host has been happily ignoring that potential problem, so
I guess it can still be ignored for a while, although we'll need to address it
eventually at one point.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
