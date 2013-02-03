Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab3BCIpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 03:45:30 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:9063 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103Ab3BCIp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 03:45:29 -0500
Message-ID: <1359881119.5717.15.camel@infinity>
Subject: Re: [PATCH 1/2] ACPI / scan: Make namespace scanning and trimming
 mutually exclusive
From: Steven Newbury <steve@snewbury.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>
Date: Sun, 03 Feb 2013 08:45:19 +0000
In-Reply-To: <1430430.JxL0tEIfZd@vostro.rjw.lan>
References: <1581701.fnbebHrKch@vostro.rjw.lan>
	 <1750337.zfO6ANFbLh@vostro.rjw.lan> <1359836881.2356.2.camel@Nokia-N900>
	 <1430430.JxL0tEIfZd@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=GaEGOwq9FwezmTggA+b6yC6zDZF2HYaK6RN/tSqdnVA= c=1 sm=0 a=aSmuriqxytUA:10 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=VwQbUJbxAAAA:8 a=Ofkj26f0c0DfH9OrCPQA:9 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-02 at 23:27 +0100, Rafael J. Wysocki wrote:
> On Saturday, February 02, 2013 08:28:01 PM Steven Newbury wrote:
> > > > Tried merging with linux-pm/bleeding-edge, same behaviour:
> > > > 
> > > > [ 3589.013578] ACPI: \_SB_.PCI0.PCIE.GDCK: undocking
> > > > [ 3589.585356] vgaarb: device changed decodes:
> > > > PCI:0000:00:02.0,olddecodes=none,decodes=io+mem:owns=none [
> > > > 3589.585422] ACPI: Delete PCI Interrupt Routing Table for 0000:04 [
> > > > 3589.585426] pci 0000:03:08.0: Oops, 'acpi_handle' corrupt [
> > > > 3589.585446] pci_bus 0000:04: busn_res: [bus 04] is released
> > > > 
> > > > 03:08.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI
> > > > Express-to-PCI Bridge (rev aa)
> > > > 04:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI
> > > > Manhattan [Mobility Radeon HD 5430 Series]
> > > > 04:00.1 Audio device: Advanced Micro Devices [AMD] nee ATI Cedar HDMI
> > > > Audio [Radeon HD 5400/6300 Series]
> > > 
> > > That's because of a bug in the dock code I believe.
> > > 
> > > If you're willing to test patches, I can try to cook up something to
> > > debug/fix this.
> > Sure, I'm always willing to test patches.
> 
> Can you please test this one in addition to the $subject one:
> 
> https://patchwork.kernel.org/patch/2068621/
> 
> and see if that helps?
No change wrt the "Oops, 'acpi_handle' corrupt".

Just to be clear, this happens during the logical undock phase after
writing to "/sys/devices/platform/dock.0/undock".

Right now I manually tear down the seat associated with the dock gfx
card (waiting for the X server to terminate and requiring SIGSTOPing the
gdm process to stop it respawning!) then attempt radeon module unload,
if it succeeds I write to the undock file, otherwise I fail the undock;
I saw there is intention to put it infrastructure to have drivers
prepare themselves for removal on 'eject' request, that would be really
helpful.

A couple of other things regarding the dock system:

Making an undock/eject request with the dock eject button results in an
ACPI 'undock' event, same ACPI event happens when the
electrical/physical undock occurs.

The IDE docks seem not to be working; maybe I need to turn on some
debugging.  This used to work at some point.

Feb  2 23:51:28 infinity kernel: ACPI: \_SB_.PCI0.IDE1.PRI_.MAST:
docking
Feb  2 23:51:28 infinity kernel: ACPI: \_SB_.PCI0.IDE1.PRI_.MAST: Unable
to dock!


