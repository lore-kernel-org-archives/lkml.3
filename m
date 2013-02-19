Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3BSQWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:22:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59543 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758571Ab3BSQWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:22:48 -0500
Date: Tue, 19 Feb 2013 11:22:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bjorn Helgaas <bhelgaas@google.com>
cc: "Artem S. Tashkinov" <t.artem@lycos.com>, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
In-Reply-To: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013, Bjorn Helgaas wrote:

> [+cc linux-pci, Rafael, Alan]
> 
> [https://bugzilla.kernel.org/show_bug.cgi?id=53551]
> 
> On Tue, Feb 12, 2013 at 1:13 PM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> > Feb 13, 2013 01:32:53 AM, Linus Torvalds wrote:
> > On Tue, Feb 12, 2013 at 10:29 AM, Artem S. Tashkinov wrote:
> >>> Feb 12, 2013 11:30:20 PM, Linus Torvalds wrote:
> >>>>
> >>>>A few things to try to pinpoint:
> >>>>
> >>>> (a) Is it *only* write performance that suffers, or is it other
> >>>>performance too? Networking (DMA? Perhaps only writing *to* the
> >>>>network?)? CPU?
> >>>
> >>> I  've tested hdpard -tT --direct and the output on boot and after suspend
> >>> is quite similar.
> >>>
> >>> I  've also checked my network read/write speed, and it  's the same
> >>> ~ 100MBit/sec (I have no 1Gbit computers on my network
> >>> unfortunately).
> >>
> >>Ok. So it really sounds like just USB and HD writes. Which is quite
> >>odd, since they have basically nothing in common I can think of
> >>(except the obvious block layer issues).

There's a slight chance that we might get some ideas by comparing
usbmon traces showing disk activity before and after the
problem-causing suspend.

Alan Stern

