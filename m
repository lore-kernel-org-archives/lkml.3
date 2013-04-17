Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966674Ab3DQSrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:47:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35791 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966608Ab3DQSrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:47:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephan von Krawczynski <skraw@ithnet.com>
Cc: Josh Boyer <jwboyer@gmail.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: No serial since kernel 3.8
Date: Wed, 17 Apr 2013 20:55:04 +0200
Message-ID: <1973551.DT5YstaY8S@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo77+A0NqZpifCCJZb7T_=o0GcBo9A6Gw5OvV2kDOppt8A@mail.gmail.com>
References: <20130416162047.2f9b83fe.skraw@ithnet.com> <20130416181432.a28e0465.skraw@ithnet.com> <CAErSpo77+A0NqZpifCCJZb7T_=o0GcBo9A6Gw5OvV2kDOppt8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 17, 2013 11:38:30 AM Bjorn Helgaas wrote:
> [+cc Rafael & linux-acpi]

Thanks.

> On Tue, Apr 16, 2013 at 10:14 AM, Stephan von Krawczynski
> <skraw@ithnet.com> wrote:
> > On Tue, 16 Apr 2013 10:59:53 -0400
> > Josh Boyer <jwboyer@gmail.com> wrote:
> >
> >> On Tue, Apr 16, 2013 at 04:55:25PM +0200, richard -rw- weinberger wrote:
> >> >On Tue, Apr 16, 2013 at 4:20 PM, Stephan von Krawczynski
> >> ><skraw@ithnet.com> wrote:
> >> >> Hello,
> >> >>
> >> >> can some kind soul please explain how I can get my serial port back under
> >> >> kernel 3.8.X. Earlier kernels showed:
> >> >>
> >> >> Jan 10 13:57:18 mybox kernel: [    0.712829] serial8250: ttyS0 at I/O 0x3f8
> >> >> (irq = 4) is a 16550A
> >> >>
> >> >> But 3.8.4:
> >> >>
> >> >> Mar 26 10:39:14 admin kernel: [    0.603647] serial 00:0a: disabled
> >> >>
> >> >> Only kernel is replaced, no change in distro
> >> >> Is there some kernel boot parameter needed now?
> >> >> I tried 3.4.X and it works, even 3.7.X works...
> >> >
> >> >So, 3.8.3 worked and 3.8.4 introduced a regression?
> >> >If so please confirm.
> >> >
> >> >CC'ing gregkh, just in case...
> >>
> >> We had a report of this in Fedora that was fixed with 3.8.7.  An upstream
> >> change had been brought back to the 3.8.x series, and it was subsequently
> >> reverted.  3.8.7 picked up the revert.
> >>
> >> josh
> >
> > 3.8.7 does not work either. I just checked it. I tried shared and not shared IRQ:
> >
> > Apr 16 17:47:05 mybox kernel: [    0.604826] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
> >
> > and another test:
> >
> > Apr 16 18:07:08 mybox kernel: [    0.601203] Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
> >
> > I must say that 3.8.7 does not even tell the "serial 00:0a: disabled" any more.
> > This is no special board, it is a pretty mainstream asus xeon board with onboard serial.
> > Loading 3.4.24 (just an example) makes the port work immediately.
> > Anything else I can test?
> 
> 3.7.6 works, and 3.8.3, 3.8.4, 3.8.7 all fail.  So it looks like a
> regression between 3.7.6 and 3.8.3.
> 
> The "serial 00:0a: disabled" message is from PNP, so I added Rafael
> and linux-acpi.  Complete dmesg logs from 3.7.6 and 3.8.4 would be a
> place to start.  Also maybe an acpidump, since the 00:0a PNP device
> probably came from PNPACPI.  You could attach all these to a
> https://bugzilla.kernel.org report if you want a place to stash them.
> 
> Josh, do you have a pointer (URL) to the Fedora issue so we can rule
> that in or out?

Stephan, below is a list of commits touching the PNP code between 3.7 and 3.8.

Can you please check if any of them has triggered the problem you're seeing?

Rafael


13cde3b PNP: Handle IORESOURCE_BITS in resource allocation
c937766 PNP: Simplify setting of resources
cdc87c5 pnpacpi: fix incorrect TEST_ALPHA() test
a6b5e88 ACPI / PNP: Do not crash due to stale pointer use during system resume
38de279 pnpbios: remove CONFIG_HOTPLUG ifdefs
2905875 ACPI / PNP: skip ACPI device nodes associated with physical nodes already
046d9ce ACPI: Move device resources interpretation code from PNP to ACPI core

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
