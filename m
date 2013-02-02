Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3BBWVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 17:21:33 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49644 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3BBWVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 17:21:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Newbury <steve@snewbury.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/2] ACPI / scan: Make namespace scanning and trimming mutually exclusive
Date: Sat, 02 Feb 2013 23:27:45 +0100
Message-ID: <1430430.JxL0tEIfZd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359836881.2356.2.camel@Nokia-N900>
References: <1581701.fnbebHrKch@vostro.rjw.lan> <1750337.zfO6ANFbLh@vostro.rjw.lan> <1359836881.2356.2.camel@Nokia-N900>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 02, 2013 08:28:01 PM Steven Newbury wrote:
> On Sat,   2 Feb 2013, 20:18:28 GMT, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Saturday, February 02, 2013 11:58:41 AM Steven Newbury wrote:
> > > On Sat, 2013-01-26 at 15:19 -0800, Yinghai Lu wrote:
> > > > On Sat, Jan 26, 2013 at 2:41 PM, Rafael J. Wysocki <rjw@sisk.pl>
> > > > wrote:
> > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > 
> > > > > There is no guarantee that acpi_bus_scan() and acpi_bus_trim() will
> > > > > not be run in parallel for the same scope of the ACPI namespace,
> > > > > which may lead to a great deal of confusion, so introduce a new
> > > > > mutex to prevent that from happening.
> > > > > 
> > > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Acked-by: Yinghai Lu <yinghai@kernel.org>
> > > > 
> > > > Steven,
> > > > 
> > > > Can you apply this one to for-pci-res-alloc to check if racing with
> > > > docking hotplug/eject
> > > > still happen?
> > > > or wait one or two days after i rebase that branch.
> > > 
> > > Tried merging with linux-pm/bleeding-edge, same behaviour:
> > > 
> > > [ 3589.013578] ACPI: \_SB_.PCI0.PCIE.GDCK: undocking
> > > [ 3589.585356] vgaarb: device changed decodes:
> > > PCI:0000:00:02.0,olddecodes=none,decodes=io+mem:owns=none [
> > > 3589.585422] ACPI: Delete PCI Interrupt Routing Table for 0000:04 [
> > > 3589.585426] pci 0000:03:08.0: Oops, 'acpi_handle' corrupt [
> > > 3589.585446] pci_bus 0000:04: busn_res: [bus 04] is released
> > > 
> > > 03:08.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI
> > > Express-to-PCI Bridge (rev aa)
> > > 04:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI
> > > Manhattan [Mobility Radeon HD 5430 Series]
> > > 04:00.1 Audio device: Advanced Micro Devices [AMD] nee ATI Cedar HDMI
> > > Audio [Radeon HD 5400/6300 Series]
> > 
> > That's because of a bug in the dock code I believe.
> > 
> > If you're willing to test patches, I can try to cook up something to
> > debug/fix this.
> Sure, I'm always willing to test patches.

Can you please test this one in addition to the $subject one:

https://patchwork.kernel.org/patch/2068621/

and see if that helps?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
