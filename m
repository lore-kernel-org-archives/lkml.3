Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3IFPi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:38:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab3IFPiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:38:55 -0400
Message-ID: <1378481674.3246.288.camel@ul30vt.home>
Subject: Re: Excess dmesg output from ACPIPHP on boot (was: Re: [PATCH
 25/30] ACPI / hotplug / PCI: Check for new devices on enabled slots)
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Fri, 06 Sep 2013 09:34:34 -0600
In-Reply-To: <CAErSpo4WAh8A7nAeDhrLUOAKrLNyEoKfyxT7VN6cyH3vuSA+zg@mail.gmail.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
	 <1411346.QqVbC9hS9U@vostro.rjw.lan> <1378422483.3246.277.camel@ul30vt.home>
	 <1599165.8kjc3DtEzc@vostro.rjw.lan>
	 <CAErSpo4WAh8A7nAeDhrLUOAKrLNyEoKfyxT7VN6cyH3vuSA+zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-06 at 06:19 -0600, Bjorn Helgaas wrote:
> On Thu, Sep 5, 2013 at 5:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, September 05, 2013 05:08:03 PM Alex Williamson wrote:
> >> On Fri, 2013-09-06 at 00:40 +0200, Rafael J. Wysocki wrote:
> >> > On Thursday, September 05, 2013 04:17:25 PM Alex Williamson wrote:
> >> > > On Thu, 2013-09-05 at 23:39 +0200, Rafael J. Wysocki wrote:
> >> > > > On Thursday, September 05, 2013 09:44:26 PM Rafael J. Wysocki wrote:
> >> > > > > On Thursday, September 05, 2013 08:21:41 AM Alex Williamson wrote:
> >> > > >
> >> > > > [...]
> >> > > >
> >> > > > > > >
> >> > > > > > > [   18.288122] pci 0000:00:00.0: no hotplug settings from platform
> >> > > > > > > [   18.288127] pcieport 0000:00:01.0: no hotplug settings from platform
> >> > > > > > > [   18.288142] pci 0000:01:00.0: no hotplug settings from platform
> >> > > > > > > [   18.288157] pci 0000:01:00.1: no hotplug settings from platform
> >> > > > > > > [   18.288162] pcieport 0000:00:03.0: no hotplug settings from platform
> >> > > > > > > [   18.288176] pci 0000:02:00.0: no hotplug settings from platform
> >> > > > > > > [   18.288190] pci 0000:02:00.1: no hotplug settings from platform
> >> > > > > > > [   18.288195] pcieport 0000:00:07.0: no hotplug settings from platform
> >> > > > > > > [   18.288209] pci 0000:03:00.0: no hotplug settings from platform
> >> > > > > > > [   18.288224] pci 0000:03:00.1: no hotplug settings from platform
> >> > > > > > > [   18.288228] pci 0000:00:14.0: no hotplug settings from platform
> >> > > > > > > [   18.288233] pci 0000:00:14.1: no hotplug settings from platform
> >> > > > > > > [   18.288237] pci 0000:00:14.2: no hotplug settings from platform
> >> > > > > > > [   18.288242] pci 0000:00:16.0: no hotplug settings from platform
> >> > > > > > > [   18.288247] pci 0000:00:16.1: no hotplug settings from platform
> >> > > > > > > [   18.288251] pci 0000:00:16.2: no hotplug settings from platform
> >> > > > > > > [   18.288256] pci 0000:00:16.3: no hotplug settings from platform
> >> > > > > > > [   18.288260] pci 0000:00:16.4: no hotplug settings from platform
> >> > > > > > > [   18.288265] pci 0000:00:16.5: no hotplug settings from platform
> >> > > > > > > [   18.288269] pci 0000:00:16.6: no hotplug settings from platform
> >> > > > > > > [   18.288274] pci 0000:00:16.7: no hotplug settings from platform
> >> > > > > > > [   18.288278] pci 0000:00:1a.0: no hotplug settings from platform
> >> > > > > > > [   18.288279] pci 0000:00:1a.0: using default PCI settings
> >> > > > > > > [   18.288292] pci 0000:00:1a.1: no hotplug settings from platform
> >> > > > > > > [   18.288293] pci 0000:00:1a.1: using default PCI settings
> >> > > > > > > [   18.288307] ehci-pci 0000:00:1a.7: no hotplug settings from platform
> >> > > > > > > [   18.288308] ehci-pci 0000:00:1a.7: using default PCI settings
> >> > > > > > > [   18.288322] pci 0000:00:1b.0: no hotplug settings from platform
> >> > > > > > > [   18.288327] pcieport 0000:00:1c.0: no hotplug settings from platform
> >> > > > > > > [   18.288332] pcieport 0000:00:1c.4: no hotplug settings from platform
> >> > > > > > > [   18.288344] pci 0000:05:00.0: no hotplug settings from platform
> >> > > > > > > [   18.288349] pci 0000:00:1d.0: no hotplug settings from platform
> >> > > > > > > [   18.288350] pci 0000:00:1d.0: using default PCI settings
> >> > > > > > > [   18.288360] pci 0000:00:1d.1: no hotplug settings from platform
> >> > > > > > > [   18.288361] pci 0000:00:1d.1: using default PCI settings
> >> > > > > > > [   18.288374] pci 0000:00:1d.2: no hotplug settings from platform
> >> > > > > > > [   18.288374] pci 0000:00:1d.2: using default PCI settings
> >> > > > > > > [   18.288387] pci 0000:00:1d.3: no hotplug settings from platform
> >> > > > > > > [   18.288387] pci 0000:00:1d.3: using default PCI settings
> >> > > > > > >
> >> > > > > > > The boot is noticeably slower.  What's going to happen on systems that
> >> > > > > > > actually have a significant I/O topology vs my little workstation?
> >> > > > >
> >> > > > > That depends on how many bus check/device check events they generate on boot.
> >> > > > >
> >> > > > > My test machines don't generate them during boot at all (even the one with
> >> > > > > a Thunderbolt connector), so I don't see the messages in question during boot
> >> > > > > on any of them.  Mika doesn't see them either I suppose, or he would have told
> >> > > > > me about that before.
> >> > > > >
> >> > > > > And let's just make it clear that it is not usual or even OK to generate bus
> >> > > > > checks or device checks during boot like this.  And since the changes in
> >> > > > > question have been in linux-next since right after the 3.11 merge window, I
> >> > > > > think that someone would have complained already had that been a common issue.
> >> > > > >
> >> > > > > Of course, we need to deal with that somehow nevertheless. :-)
> >> > > > >
> >> > > > > > Just to give you an idea:
> >> > > > > >
> >> > > > > > CONFIG_HOTPLUG_PCI_ACPI=y
> >> > > > > >
> >> > > > > > $ dmesg | wc
> >> > > > > >   5697  49935 384368
> >> > > > > >
> >> > > > > > $ dmesg | tail --lines=1
> >> > > > > > [   53.137123] Ebtables v2.0 registered
> >> > > > > >
> >> > > > > > -- vs --
> >> > > > > >
> >> > > > > > # CONFIG_HOTPLUG_PCI_ACPI is not set
> >> > > > > >
> >> > > > > > $ dmesg | wc
> >> > > > > >  1053  9176 71652
> >> > > > > >
> >> > > > > > $dmesg | tail --lines=1
> >> > > > > > [   28.917220] Ebtables v2.0 registered
> >> > > > > >
> >> > > > > > So it spews out 5x more output with acpiphp enabled and takes and extra
> >> > > > > > 24s to boot (nearly 2x).  Not good.
> >> > > > >
> >> > > > > The "no hotplug settings from platform" message is from pci_configure_slot().
> >> > > > > I think the messages you're seeing are from the call to it in
> >> > > > > acpiphp_set_hpp_values() which is called by enable_slot().
> >> > > > >
> >> > > > > There, I think, we can simply check the return value of pci_scan_slot() and
> >> > > > > if that is 0 (no new devices), we can just skip everything under the call to
> >> > > > > __pci_bus_assign_resources().
> >> > > > >
> >> > > > > However, we can't skip the scanning of bridges, if any, because there may be
> >> > > > > new devices below them and I guess that's what takes so much time on your
> >> > > > > machine.
> >> > > >
> >> > > > OK, one piece is missing.  We may need to evaluate _OSC after handling each
> >> > > > event to let the platform know the status.
> >> > > >
> >> > > > Can you please check if the appended patch makes any difference (with the
> >> > > > previous fix applied, of course)?
> >> > > >
> >> > > > If fact, it is two patches combined.  One of them optimizes enable_slot()
> >> > > > slightly and the other adds the missing _OSC evaluation.
> >> > >
> >> > > Better, still double the output:
> >> > >
> >> > > $ dmesg | wc
> >> > >    2169   19047  152710
> >> >
> >> > I see.
> >> >
> >> > What about the timing?
> >>
> >> ~40s below vs ~29s for acpiphp config'd out above.
> >
> > Well, that's better than before.
> >
> > I'll prepare "official" patches with the last changes then too.
> >
> >> > > $ dmesg | tail --lines=1
> >> > > [   39.980918] Ebtables v2.0 registered
> >> > >
> >> > > Here's another interesting stat:
> >> > >
> >> > > $ dmesg | colrm 1 15 | sort | uniq -c | sort -nr | head --lines=25
> >> > >      73 pci 0000:00:1f.0: BAR 13: [io  0x1000-0x107f] has bogus alignment
> >> > >      73 pci 0000:00:1e.0: PCI bridge to [bus 06]
> >> > >      64 pci 0000:00:1e.0:   bridge window [mem 0x81100000-0x812fffff 64bit pref]
> >> > >      64 pci 0000:00:1e.0:   bridge window [mem 0x80f00000-0x810fffff]
> >> > >      64 pci 0000:00:1e.0:   bridge window [io  0x7000-0x7fff]
> >> > >      38 pci 0000:00:1c.4: PCI bridge to [bus 05]
> >> > >      38 pci 0000:00:1c.4:   bridge window [mem 0xf4f00000-0xf4ffffff]
> >> > >      38 pci 0000:00:1c.0: PCI bridge to [bus 04]
> >> > >      38 pci 0000:00:07.0: PCI bridge to [bus 03]
> >> > >      38 pci 0000:00:07.0:   bridge window [mem 0xf2000000-0xf40fffff]
> >> > >      38 pci 0000:00:07.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
> >> > >      38 pci 0000:00:07.0:   bridge window [io  0x4000-0x4fff]
> >> > >      38 pci 0000:00:03.0: PCI bridge to [bus 02]
> >> > >      38 pci 0000:00:03.0:   bridge window [mem 0xf4e00000-0xf4efffff]
> >> > >      38 pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
> >> > >      38 pci 0000:00:03.0:   bridge window [io  0x3000-0x3fff]
> >> > >      38 pci 0000:00:01.0: PCI bridge to [bus 01]
> >> > >      38 pci 0000:00:01.0:   bridge window [mem 0xf4100000-0xf4bfffff]
> >> > >      38 pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> >> > >      37 pci 0000:00:1c.4:   bridge window [mem 0x80c00000-0x80dfffff 64bit pref]
> >> > >      37 pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
> >> > >      37 pci 0000:00:1c.0:   bridge window [mem 0x80a00000-0x80bfffff 64bit pref]
> >> > >      37 pci 0000:00:1c.0:   bridge window [mem 0x80800000-0x809fffff]
> >> > >      37 pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
> >> > >      36 pci 0000:00:01.0:   bridge window [mem 0x80000000-0x807fffff 64bit pref]
> >> > >
> >> > > This is nearly the entire difference, just 25 lines repeated over and
> >> > > over.
> >
> > Can you check how many times the lines above are repeated?
> >
> >> >
> >> > Well, this is the bridge sizing I talked about previously.  We still get
> >> > apparently spurious bus check/device check events and they trigger bridge
> >> > scans.
> >> >
> >> > I'm not sure what to do about that and I wonder whether or not this is
> >> > reproducible on any other machines you can test.
> >>
> >> I can try it on a couple other systems, but probably not until tomorrow.
> >
> > Tomorrow (or even later) works just fine for me. :-)
> >
> >> > Can you please change dbg() to pr_info() under ACPI_NOTIFY_BUS_CHECK and
> >> > ACPI_NOTIFY_DEVICE_CHECK in hotplug_event() (acpiphp_glue.c), grep the boot
> >> > dmesg log for "check notify" and send the result?  I'm wondering what's
> >> > going on there.
> >>
> >> $ dmesg | grep "check notify"
> >> [    1.633228] hotplug_event: Device check notify on \_SB_.PCI0.PEX2
> >> [    2.472004] hotplug_event: Device check notify on \_SB_.PCI0.PEX3
> >> [    2.477288] hotplug_event: Device check notify on \_SB_.PCI0.PEX4
> >> [    2.482571] hotplug_event: Device check notify on \_SB_.PCI0.PEX5
> >> [    2.482579] hotplug_event: Device check notify on \_SB_.PCI0.PEX6
> >> [    8.204953] hotplug_event: Device check notify on \_SB_.PCI0.PEX2
> >> [    8.209632] hotplug_event: Device check notify on \_SB_.PCI0.PEX3
> >> [    8.214272] hotplug_event: Device check notify on \_SB_.PCI0.PEX4
> >> [    8.218894] hotplug_event: Device check notify on \_SB_.PCI0.PEX5
> >> [    8.218901] hotplug_event: Device check notify on \_SB_.PCI0.PEX6
> >
> > So I guess the PEXn things are PCIe ports and we get two notifications
> > for each of them, so everything below them gets rescanned.
> >
> > I've just talked to Bjorn about that and we don't seem to have a good idea
> > how to handle this.  The notifies shouldn't be there, but we kind of have
> > to handle them.
> 
> What I said was "We aren't going to be able to get rid of the
> notifications, but we can probably figure out how to clean up some of
> the output."  I don't think there's anything *wrong* with the
> notifications themselves, and as far as I know, there's nothing in the
> spec that limits how many notifications the platform can send.
> 
> > I guess we could suppress the output from repeated bridge scans.  Alternatively,
> > we could just blacklist this particular system somehow if the problem is
> > specific to it.
> 
> I'm opposed to blacklisting in principle because this doesn't sound
> like a platform defect.  And I think we pretty much have to
> re-enumerate for each Device Check, because that's what the spec tells
> us to do.
> 
> My goal is for PCI to print stuff only for significant events, when we
> discover something new, or when we change something (BAR, bridge
> window, etc.)  A hot-plug event, e.g., a Device Check, is arguably
> significant all by itself, but that's in ACPI, and it sounds like we
> only have a dbg() there now.  The repeated PCI bridge info seems like
> it's useless.  I've looked at cleaning up some of that in the past,
> but it wasn't trivial and it wasn't urgent enough at the time.  But it
> sure sounds urgent now.
> 
> Alex, would you mind collecting the full dmesg or console log (with
> "debug ignore_loglevel") and "lspci -vv" output and attaching them to
> a bugzilla?  Keep the hotplug_event() pr_info() change so we have more
> clues about what triggers things.  This seems like an interesting
> situation, and there might be other things we can learn from it.  It
> looks like the "hotplug settings" output is probably more than is
> necessary also.

bz here:

https://bugzilla.kernel.org/show_bug.cgi?id=60865

Thanks,
Alex

