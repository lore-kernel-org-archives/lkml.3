Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaBRRbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:31:24 -0500
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:47520
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbaBRRbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:31:22 -0500
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.1 cv=Qfbov6rv c=1 sm=1 tr=0 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
 a=rTb9Q+mClrhkGV9Ah9iRIA==:17 a=N1CowNylAAAA:8 a=IkcTkHD0fZMA:10
 a=o3pxq7NaF3wA:10 a=1XWaLZrsAAAA:8 a=_Cv-zV17sKTOCWXdU-oA:9 a=QEXdDO2ut3YA:10
 a=UTB_XpHje0EA:10
Message-ID: <1392744674.15829.31.camel@artifact>
Subject: Re: pci-3.14 resource alloc
From: Steven Newbury <steve@snewbury.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 18 Feb 2014 17:31:14 +0000
In-Reply-To: <CAErSpo4CLB7G5DHpdr69t+wZjywuOXKXsvS6W3eTMJgU5Xpycg@mail.gmail.com>
References: <1390773698.3450.12.camel@artifact>
	 <CAE9FiQVD=oVHM5WJgSJ5cNpXZ1NYy9E_pcGWfjKnmD9OZoHHsw@mail.gmail.com>
	 <1391643656.1067.1.camel@artifact>
	 <CAE9FiQV8jutRhaBicL4kjqVYd07FzHmNoSN3NxdA2TYvOc_KUg@mail.gmail.com>
	 <z9zi9m.n0zpxd.1hgeaud-qmf@mail.snewbury.org.uk>
	 <i9nn22.n0zs79.1hgeaud-qmf@mail.snewbury.org.uk>
	 <1392392764.3520.11.camel@devel-n900>
	 <CAE9FiQV3H_nxH0gxcM0kW4uLm6b_qmHT9hRQUVY_4xPqjpvMtA@mail.gmail.com>
	 <1392718107.15829.12.camel@artifact>
	 <CAErSpo6cnT6JDh0rj_3TCjw8vkLbM0ztzES0Qh1R=wUCp0PfTw@mail.gmail.com>
	 <CAErSpo4CLB7G5DHpdr69t+wZjywuOXKXsvS6W3eTMJgU5Xpycg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 07:37 -0700, Bjorn Helgaas wrote:
> On Tue, Feb 18, 2014 at 6:59 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Tue, Feb 18, 2014 at 3:08 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
> 
> >> No, the only unusual option is I use pci=nocrs since the bios is
> >> completely ignorant of support for 64bit BARs.
> >
> > Hi Steven, this is a tangent, but can you collect the complete dmesg
> > log with "pci=nocrs" and let me know what happens when you *don't* use
> > "pci=nocrs" (a complete dmesg log there would be useful too, but I
> > don't know if you can boot without it)?  I think Linux *should* be
> > able to handle 64bit BARs even if the BIOS doesn't.
> >
> > Please post these as a separate thread so we don't muddle this
> > conversation with Yinghai.
> 
> Oh, never mind.  I think I remember now.  I think the problem is not
> so much that the BIOS doesn't handle 64bit *BARs*, but that your BIOS
> doesn't report 64bit host bridge *apertures*, and you want to use
> space above 4G for a graphics card or something.
> 
Yes, exactly. I should have stated it better.  I need to push the
on-board i965 up above 4G to make room for a radeon which is accessed
through a 32 bit only bridge.  The BIOS doesn't provide any
functionality like this.  The intel devs seemed a little surprised that
the i965 actually worked stably in this configuration given known
errata, but I've actually had no problems with this side of things. 

> That's not really anything we can fix in PCI because PCI doesn't
> discover those apertures.  Host bridge drivers like the generic ACPI
> pci_root.c or the native amd_bus.c discover them.  If those drivers
> don't discover them, PCI can't just make them up.

32 bit only bridges must be getting pretty rare by now, and I presume
any new hardware out there with a dockable PCI bus would provide 64 bit
resource allocation for host bridge apertures when booting to a 64 bit
OS?  Maybe not?
> 
> It might be nice if we had cleaner kernel options to say "assume a
> host bridge window here" and "put this device here," so you didn't
> have to use the big hammer of "pci=nocrs".  It's sort of a pain to
> figure out how to attach info like that to the correct device (there
> might be several host bridges, so how do you specify which one you
> care about?), but maybe it could be done.
> 
That would be much better, even if it's only some way to say "ignore crs
for *this* host bridge (and parents)", or "for host bridges to which
*this* device is attached".


