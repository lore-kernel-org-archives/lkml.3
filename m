Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab3HBI0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:26:31 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63037 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab3HBI02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:26:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+F7fdONZkIZOylTutgQncb
Date: Fri, 2 Aug 2013 01:26:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130802082622.GB7656@atomide.com>
References: <20130731073802.GT7656@atomide.com>
 <20130731123351.GA30474@kroah.com>
 <20130802075352.GY7656@atomide.com>
 <20130802080335.GM24465@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802080335.GM24465@radagast>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130802 01:11]:
> Hi,
> 
> On Fri, Aug 02, 2013 at 12:53:53AM -0700, Tony Lindgren wrote:
> > > > Basically the data bloat issue is there for the arch code and drivers
> > > > and may not show up initially until things have headed the wrong way for
> > > > too long.
> > > 
> > > What do you mean by this?  You seem to be very vague here.
> > 
> > People are unnecessarily defining registers in kernel for similar devices
> > over and over again for each new SoC at the arch level and now more and
> > more at the driver level.
> >
> > One example of that are device tree based drivers that don't describe
> > the actual hardware, but instead have a binding that points to an index
> > of defined registers in the driver.
> 
> -ECONFUSED... DT passes only the base address and the size of the
> address space. If some versions of the IP have slightly different
> register layout, that needs to be treated at the driver, right ?

The driver shoud know how to handle various _types_ of registers rather
than contain a data what these registers are. Then the DT should define
the _types_ of registers that the hardware has. Any register names etc
are just debug data that can be handled with userspace tools using debugfs.
 
> > One way to avoid these kind of bloat issues is to allow drivers to load
> > data at multiple points: Only abtolutely minimal set of data should be
> > static, some should only come from the bootloader as a device tree or
> > ACPI tables, and some is best to be loaded after booting from /lib/firmware.
> 
> why would we put data blobs in /lib/firmware ? I know we have discussed
> this at some length before, but I still don't get the idea that, just
> because data shouldn't be in the kernel, we would bloat /lib/firmware
> with blobs which aren't really firmwares.

Because the amount of data coming from the bootloader should be pretty
minimal. And it is for ACPI, and device tree will run into performance
issues trying stuff all the data there.

And a huge amount of the data we have in platform_data, defined registers,
device tree etc is only needed by the kernel for debugging, or is only
needed later on for things like PM.
 
> It would be like adding ACPI tables to /lib/firmware :-p

I don't think ACPI has this issue, the set of data coming from ACPI
is pretty minimal. But I bet a lot of the ACPI drivers could also load
the debug related data as additional kernel modules or from /lib/firmware
especially if it's somehow SoC or board specific.

Regards,

Tony
