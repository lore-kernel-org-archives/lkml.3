Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3IFNgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:36:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36756 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab3IFNgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:36:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 0/2] Re: Excess dmesg output from ACPIPHP on boot
Date: Fri, 06 Sep 2013 15:42:20 +0200
Message-ID: <2228690.GcUDD3xFfP@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1599165.8kjc3DtEzc@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <1378422483.3246.277.camel@ul30vt.home> <1599165.8kjc3DtEzc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 06, 2013 01:36:28 AM Rafael J. Wysocki wrote:
> On Thursday, September 05, 2013 05:08:03 PM Alex Williamson wrote:
> > On Fri, 2013-09-06 at 00:40 +0200, Rafael J. Wysocki wrote:
> > > On Thursday, September 05, 2013 04:17:25 PM Alex Williamson wrote:
> > > > On Thu, 2013-09-05 at 23:39 +0200, Rafael J. Wysocki wrote:
> > > > > On Thursday, September 05, 2013 09:44:26 PM Rafael J. Wysocki wrote:
> > > > > > On Thursday, September 05, 2013 08:21:41 AM Alex Williamson wrote:
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > > > 
> > > > > > > > [   18.288122] pci 0000:00:00.0: no hotplug settings from platform
> > > > > > > > [   18.288127] pcieport 0000:00:01.0: no hotplug settings from platform
> > > > > > > > [   18.288142] pci 0000:01:00.0: no hotplug settings from platform
> > > > > > > > [   18.288157] pci 0000:01:00.1: no hotplug settings from platform
> > > > > > > > [   18.288162] pcieport 0000:00:03.0: no hotplug settings from platform
> > > > > > > > [   18.288176] pci 0000:02:00.0: no hotplug settings from platform
> > > > > > > > [   18.288190] pci 0000:02:00.1: no hotplug settings from platform
> > > > > > > > [   18.288195] pcieport 0000:00:07.0: no hotplug settings from platform
> > > > > > > > [   18.288209] pci 0000:03:00.0: no hotplug settings from platform
> > > > > > > > [   18.288224] pci 0000:03:00.1: no hotplug settings from platform
> > > > > > > > [   18.288228] pci 0000:00:14.0: no hotplug settings from platform
> > > > > > > > [   18.288233] pci 0000:00:14.1: no hotplug settings from platform
> > > > > > > > [   18.288237] pci 0000:00:14.2: no hotplug settings from platform
> > > > > > > > [   18.288242] pci 0000:00:16.0: no hotplug settings from platform
> > > > > > > > [   18.288247] pci 0000:00:16.1: no hotplug settings from platform
> > > > > > > > [   18.288251] pci 0000:00:16.2: no hotplug settings from platform
> > > > > > > > [   18.288256] pci 0000:00:16.3: no hotplug settings from platform
> > > > > > > > [   18.288260] pci 0000:00:16.4: no hotplug settings from platform
> > > > > > > > [   18.288265] pci 0000:00:16.5: no hotplug settings from platform
> > > > > > > > [   18.288269] pci 0000:00:16.6: no hotplug settings from platform
> > > > > > > > [   18.288274] pci 0000:00:16.7: no hotplug settings from platform
> > > > > > > > [   18.288278] pci 0000:00:1a.0: no hotplug settings from platform
> > > > > > > > [   18.288279] pci 0000:00:1a.0: using default PCI settings
> > > > > > > > [   18.288292] pci 0000:00:1a.1: no hotplug settings from platform
> > > > > > > > [   18.288293] pci 0000:00:1a.1: using default PCI settings
> > > > > > > > [   18.288307] ehci-pci 0000:00:1a.7: no hotplug settings from platform
> > > > > > > > [   18.288308] ehci-pci 0000:00:1a.7: using default PCI settings
> > > > > > > > [   18.288322] pci 0000:00:1b.0: no hotplug settings from platform
> > > > > > > > [   18.288327] pcieport 0000:00:1c.0: no hotplug settings from platform
> > > > > > > > [   18.288332] pcieport 0000:00:1c.4: no hotplug settings from platform
> > > > > > > > [   18.288344] pci 0000:05:00.0: no hotplug settings from platform
> > > > > > > > [   18.288349] pci 0000:00:1d.0: no hotplug settings from platform
> > > > > > > > [   18.288350] pci 0000:00:1d.0: using default PCI settings
> > > > > > > > [   18.288360] pci 0000:00:1d.1: no hotplug settings from platform
> > > > > > > > [   18.288361] pci 0000:00:1d.1: using default PCI settings
> > > > > > > > [   18.288374] pci 0000:00:1d.2: no hotplug settings from platform
> > > > > > > > [   18.288374] pci 0000:00:1d.2: using default PCI settings
> > > > > > > > [   18.288387] pci 0000:00:1d.3: no hotplug settings from platform
> > > > > > > > [   18.288387] pci 0000:00:1d.3: using default PCI settings
> > > > > > > > 
> > > > > > > > The boot is noticeably slower.  What's going to happen on systems that
> > > > > > > > actually have a significant I/O topology vs my little workstation?
> > > > > > 
> > > > > > That depends on how many bus check/device check events they generate on boot.
> > > > > > 
> > > > > > My test machines don't generate them during boot at all (even the one with
> > > > > > a Thunderbolt connector), so I don't see the messages in question during boot
> > > > > > on any of them.  Mika doesn't see them either I suppose, or he would have told
> > > > > > me about that before.
> > > > > > 
> > > > > > And let's just make it clear that it is not usual or even OK to generate bus
> > > > > > checks or device checks during boot like this.  And since the changes in
> > > > > > question have been in linux-next since right after the 3.11 merge window, I
> > > > > > think that someone would have complained already had that been a common issue.
> > > > > > 
> > > > > > Of course, we need to deal with that somehow nevertheless. :-)
> > > > > > 
> > > > > > > Just to give you an idea:
> > > > > > > 
> > > > > > > CONFIG_HOTPLUG_PCI_ACPI=y
> > > > > > > 
> > > > > > > $ dmesg | wc
> > > > > > >   5697  49935 384368
> > > > > > > 
> > > > > > > $ dmesg | tail --lines=1
> > > > > > > [   53.137123] Ebtables v2.0 registered
> > > > > > > 
> > > > > > > -- vs --
> > > > > > > 
> > > > > > > # CONFIG_HOTPLUG_PCI_ACPI is not set
> > > > > > > 
> > > > > > > $ dmesg | wc
> > > > > > >  1053  9176 71652
> > > > > > > 
> > > > > > > $dmesg | tail --lines=1
> > > > > > > [   28.917220] Ebtables v2.0 registered
> > > > > > > 
> > > > > > > So it spews out 5x more output with acpiphp enabled and takes and extra
> > > > > > > 24s to boot (nearly 2x).  Not good.
> > > > > > 
> > > > > > The "no hotplug settings from platform" message is from pci_configure_slot().
> > > > > > I think the messages you're seeing are from the call to it in
> > > > > > acpiphp_set_hpp_values() which is called by enable_slot().
> > > > > > 
> > > > > > There, I think, we can simply check the return value of pci_scan_slot() and
> > > > > > if that is 0 (no new devices), we can just skip everything under the call to
> > > > > > __pci_bus_assign_resources().
> > > > > > 
> > > > > > However, we can't skip the scanning of bridges, if any, because there may be
> > > > > > new devices below them and I guess that's what takes so much time on your
> > > > > > machine.
> > > > > 
> > > > > OK, one piece is missing.  We may need to evaluate _OSC after handling each
> > > > > event to let the platform know the status.
> > > > > 
> > > > > Can you please check if the appended patch makes any difference (with the
> > > > > previous fix applied, of course)?
> > > > > 
> > > > > If fact, it is two patches combined.  One of them optimizes enable_slot()
> > > > > slightly and the other adds the missing _OSC evaluation.
> > > > 
> > > > Better, still double the output:
> > > > 
> > > > $ dmesg | wc
> > > >    2169   19047  152710
> > > 
> > > I see.
> > > 
> > > What about the timing?
> > 
> > ~40s below vs ~29s for acpiphp config'd out above.
> 
> Well, that's better than before.
> 
> I'll prepare "official" patches with the last changes then too.

The patches follow as [1/2] and [2/2].  The change in enable_slot() is
literally the same, but the _OST patch is somewhat different, although the
changes mostly affect the eject code path and the notifies that we don't
actually handle, so they should not matter on your machine.

Thanks,
Rafael

