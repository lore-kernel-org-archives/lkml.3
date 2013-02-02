Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3BBUZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 15:25:19 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:32647 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172Ab3BBUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 15:25:17 -0500
From: Steven Newbury <steve@snewbury.org.uk>
Reply-To: Steven Newbury <steve@snewbury.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/2] ACPI / scan: Make namespace scanning and trimming
	mutually exclusive
X-Mailer: Modest 3.90.7
References: <1581701.fnbebHrKch@vostro.rjw.lan>
	 <CAE9FiQV+DDb0ap=sipQjUWCdz8Qsfs2dYDVrb0FmKL4F1BjhOw@mail.gmail.com>
	 <1359806321.30277.3.camel@infinity>  <1750337.zfO6ANFbLh@vostro.rjw.lan>
In-Reply-To: <1750337.zfO6ANFbLh@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-ID: <1359836880.2356.1.camel@Nokia-N900>
Date: Sat, 02 Feb 2013 20:28:01 +0000
Message-Id: <1359836881.2356.2.camel@Nokia-N900>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=AUhbpHVS+xhHrj9wLCYAQoYnFLYUZdbP8UM0GmH2jwk= c=1 sm=0 a=aSmuriqxytUA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=9dGwNIE38D9QVD7LUlMA:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=LI9Vle30uBYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,   2 Feb 2013, 20:18:28 GMT, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Saturday, February 02, 2013 11:58:41 AM Steven Newbury wrote:
> > On Sat, 2013-01-26 at 15:19 -0800, Yinghai Lu wrote:
> > > On Sat, Jan 26, 2013 at 2:41 PM, Rafael J. Wysocki <rjw@sisk.pl>
> > > wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > There is no guarantee that acpi_bus_scan() and acpi_bus_trim() will
> > > > not be run in parallel for the same scope of the ACPI namespace,
> > > > which may lead to a great deal of confusion, so introduce a new
> > > > mutex to prevent that from happening.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Acked-by: Yinghai Lu <yinghai@kernel.org>
> > > 
> > > Steven,
> > > 
> > > Can you apply this one to for-pci-res-alloc to check if racing with
> > > docking hotplug/eject
> > > still happen?
> > > or wait one or two days after i rebase that branch.
> > 
> > Tried merging with linux-pm/bleeding-edge, same behaviour:
> > 
> > [ 3589.013578] ACPI: \_SB_.PCI0.PCIE.GDCK: undocking
> > [ 3589.585356] vgaarb: device changed decodes:
> > PCI:0000:00:02.0,olddecodes=none,decodes=io+mem:owns=none [
> > 3589.585422] ACPI: Delete PCI Interrupt Routing Table for 0000:04 [
> > 3589.585426] pci 0000:03:08.0: Oops, 'acpi_handle' corrupt [
> > 3589.585446] pci_bus 0000:04: busn_res: [bus 04] is released
> > 
> > 03:08.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI
> > Express-to-PCI Bridge (rev aa)
> > 04:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI
> > Manhattan [Mobility Radeon HD 5430 Series]
> > 04:00.1 Audio device: Advanced Micro Devices [AMD] nee ATI Cedar HDMI
> > Audio [Radeon HD 5400/6300 Series]
> 
> That's because of a bug in the dock code I believe.
> 
> If you're willing to test patches, I can try to cook up something to
> debug/fix this.
Sure, I'm always willing to test patches.
