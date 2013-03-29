Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab3C2KvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:51:07 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43192 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3C2KvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:51:05 -0400
Message-ID: <1364554250.3559.61.camel@thor.lan>
Subject: Re: [PATCH] firewire: Enable physical DMA above 4GB
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>
Date: Fri, 29 Mar 2013 06:50:50 -0400
In-Reply-To: <20130329114409.3634676e@stein>
References: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
	 <20130326195653.470b09d6@stein> <1364324929.3866.13.camel@thor.lan>
	 <20130326213532.38a7bd4c@stein> <20130329114409.3634676e@stein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 11:44 +0100, Stefan Richter wrote:
> On Mar 26 Stefan Richter wrote:
> > On Mar 26 Peter Hurley wrote:
> > > On Tue, 2013-03-26 at 19:56 +0100, Stefan Richter wrote:
> > > > It has been a long time though since I last checked whether PhyUpperBound
> > > > is implemented; maybe it has become more widespread than it was back then.
> > > > 
> > > > Or maybe it hasn't:  All OHCI-1394 chips that ever came to market are 32
> > > > bit chips anyway.  So the few rare ones that do support PhyUpperBound
> > > > larger than 4 GB cannot in fact use it.
> > > > 
> > > > Or am I severely behind the times about this?
> > > 
> > > The FW643e-2 is natively PCIe (not behind a bridge) and supports phys
> > > DMA past 4GB (the datasheet says all 48 bits but I can only test it out
> > > to 10GB).
> > > 
> > > I thought the FW643e was as well? You'll have to test that out :)
> > 
> > OK, will do.
> 
> Does lspci or something similar show which PCI devices are capable of 64 bit
> wide addressing?

Not definitively.

Usually (but not always), if the host registers are 64-bit addressable,
then the device supports DAC. But that's not something that can be
relied on programmatically.

For example, lspci on FW643e-2:
06:00.0 FireWire (IEEE 1394): LSI Corporation FW643 [TrueFire] PCIe 1394b Controller (rev 08) (prog-if 10 [OHCI])
	Subsystem: LSI Corporation FW643 [TrueFire] PCIe 1394b Controller
	Flags: bus master, fast devsel, latency 0, IRQ 89
==>	Memory at dbeff000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

By contrast, lspci on FW323 on same machine:
07:06.0 FireWire (IEEE 1394): LSI Corporation FW322/323 [TrueFire] 1394a Controller (rev 70) (prog-if 10 [OHCI])
	Subsystem: Dell Device 5811
	Flags: bus master, medium devsel, latency 64, IRQ 30
==>	Memory at dbbff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci


