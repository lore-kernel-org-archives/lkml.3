Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaIPQpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:45:24 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41282 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaIPQpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:45:22 -0400
Date: Tue, 16 Sep 2014 10:45:18 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: 3.14 radeon regression: radeon is broken (pci bug?)
Message-ID: <20140916164518.GA1847@google.com>
References: <CALCETrVG6uRysbXSbyPfKzG7uBHu9PX6SKvDbUQWG1TOfc04zQ@mail.gmail.com>
 <CADnq5_NJLsF4MmcQVN7jDD6-ZjAobw0bf2ft2HWGid6GMcXWcA@mail.gmail.com>
 <CALCETrVjHkdbe5N4iov-7dg6tGmuFsr70z2ASpX+=km=FMWe7Q@mail.gmail.com>
 <CAErSpo4J-rEkr-xDojZNTShRxoimUsYcFwrY-K4K3sZ3rporRw@mail.gmail.com>
 <CALCETrVtfvBu0=2hofkSfh-ohrnUCS18yE4N0UYg7kqjJYBp1g@mail.gmail.com>
 <CAErSpo71-t_c1dh_B7-HJD45Yd_0WZr1pUK6cn4uOtPUiGQ7Jw@mail.gmail.com>
 <CAErSpo5LuKUNFiEy4=tRcT-aXpbkZkWQxpfajYRngt65WS852Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5LuKUNFiEy4=tRcT-aXpbkZkWQxpfajYRngt65WS852Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 11:30:37AM -0600, Bjorn Helgaas wrote:
> On Mon, Mar 24, 2014 at 4:04 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Sat, Mar 22, 2014 at 9:18 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> On Fri, Mar 21, 2014 at 9:37 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>> On Fri, Mar 21, 2014 at 9:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> >>>> On Fri, Mar 21, 2014 at 7:41 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> >>>>> On Thu, Mar 20, 2014 at 10:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >>>>>> My system works on a 3.13 Fedora kernel.  It does not work on a
> >>>>>> more-or-less identically configured 3.14-rc7+ kernel.  The symptom is
> >>>>>> that the Plymouth password prompt flashes and them the screen goes
> >>>>>> blank.  Hitting escape brings back the text console, and all is well
> >>>>>> until X tries to start.  Then I get a blank screen.  killall -9 Xorg
> >>>>>> from ssh causes these errors to be logged:
> >>>>>>
> >>>>>>
> >>>>>> [  226.239747] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
> >>>>>> more than 5secs aborting
> >>>>>> [  226.239751] [drm:atom_execute_table_locked] *ERROR* atombios stuck
> >>>>>> executing CD34 (len 55, WS 0, PS 0) @ 0xCD57
> >>>>>> [  231.241492] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
> >>>>>> more than 5secs aborting
> >>>>>> [  231.241496] [drm:atom_execute_table_locked] *ERROR* atombios stuck
> >>>>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
> >>>>>> [  236.243111] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
> >>>>>> more than 5secs aborting
> >>>>>> [  236.243115] [drm:atom_execute_table_locked] *ERROR* atombios stuck
> >>>>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
> >>>>>> [  241.244625] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
> >>>>>> more than 5secs aborting
> >>>>>> [  241.244628] [drm:atom_execute_table_locked] *ERROR* atombios stuck
> >>>>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
> >>>>>>
> >>>>>>
> >>>>>> lspci -vvvxxxnn on 3.14-rc7+ says:
> >>>>>>
> >>>>>> 09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
> >>>>>> [AMD/ATI] Caicos [Radeon HD 6450/7450/8450 / R5 230 OEM] [1002:6779]
> >>>>>> (rev ff) (prog-if ff)
> >>>>>>     !!! Unknown header type 7f
> >>>>>>     Kernel driver in use: radeon
> >>>>>> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>>>>> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>>>>> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>>>>> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>>>>>
> >>>>>> 09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
> >>>>>> Caicos HDMI Audio [Radeon HD 6400 Series] [1002:aa98] (rev ff)
> >>>>>> (prog-if ff)
> >>>>>>     !!! Unknown header type 7f
> >>>>>>     Kernel driver in use: snd_hda_intel
> >>>>>> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>>>>> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>>>>> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>>>>> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >>>>>>
> >>>>>> (oops!)
> >>>>>>
> >>>>>> On 3.13, it says:
> >>>>>>
> >>>>>> 09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
> >>>>>> [AMD/ATI] Caicos [Radeon HD 6450/7450/8450 / R5 230 OEM] [1002:6779]
> >>>>>> (prog-if 00 [VGA controller])
> >>>>>>         Subsystem: PC Partner Limited / Sapphire Technology Radeon HD
> >>>>>> 6450 1 GB DDR3 [174b:e164]
> >>>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> >>>>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
> >>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> >>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>>>>>         Latency: 0, Cache Line Size: 64 bytes
> >>>>>>         Interrupt: pin A routed to IRQ 92
> >>>>>>         Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
> >>>>>>         Region 2: Memory at f4a20000 (64-bit, non-prefetchable) [size=128K]
> >>>>>>         Region 4: I/O ports at c000 [size=256]
> >>>>>>         Expansion ROM at f4a00000 [disabled] [size=128K]
> >>>>>>         Capabilities: <access denied>
> >>>>>>         Kernel driver in use: radeon
> >>>>>> 00: 02 10 79 67 07 04 10 00 00 00 00 03 10 00 80 00
> >>>>>> 10: 0c 00 00 e0 00 00 00 00 04 00 a2 f4 00 00 00 00
> >>>>>> 20: 01 c0 00 00 00 00 00 00 00 00 00 00 4b 17 64 e1
> >>>>>> 30: 00 00 a0 f4 50 00 00 00 00 00 00 00 0a 01 00 00
> >>>>>>
> >>>>>> 09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
> >>>>>> Caicos HDMI Audio [Radeon HD 6400 Series] [1002:aa98]
> >>>>>>         Subsystem: PC Partner Limited / Sapphire Technology Radeon HD
> >>>>>> 6450 1GB DDR3 [174b:aa98]
> >>>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> >>>>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
> >>>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> >>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>>>>>         Latency: 0, Cache Line Size: 64 bytes
> >>>>>>         Interrupt: pin B routed to IRQ 96
> >>>>>>         Region 0: Memory at f4a40000 (64-bit, non-prefetchable) [size=16K]
> >>>>>>         Capabilities: <access denied>
> >>>>>>         Kernel driver in use: snd_hda_intel
> >>>>>> 00: 02 10 98 aa 06 04 10 00 00 00 03 04 10 00 80 00
> >>>>>> 10: 04 00 a4 f4 00 00 00 00 00 00 00 00 00 00 00 00
> >>>>>> 20: 00 00 00 00 00 00 00 00 00 00 00 00 4b 17 98 aa
> >>>>>> 30: 00 00 00 00 50 00 00 00 00 00 00 00 05 02 00 00
> >>>>>>
> >>>>>> Logs attached.
> >>>
> >>> Hi Andy,
> >>>
> >>> I'm really sorry that you tripped over this, but thanks a lot for the
> >>> report.  Is there any chance the box is currently running v3.13, and
> >>> you could collect the dmesg log from it?  I don't see anything unusual
> >>> from a PCI perspective in the v3.14-rc7 dmesg; all the PCI device
> >>> resources look fine, and we didn't reassign anything.  It seems like
> >>> the 0000:09:00.x devices just stopped responding for some reason, and
> >>> the PCI core shouldn't really be involved after the radeon driver
> >>> claims and enables those devices.  But it's possible I'd get a clue by
> >>> comparing the v3.13 and v3.14-rc7 dmesg logs.
> >>
> >> Attached.  I also clearly screwed something up about my 3.14 config --
> >> I meant for it to match the Fedora config, but it doesn't.  At least
> >> NR_CPUs is too low.  That shoudn't break radeon, but maybe something
> >> odd happens.
> >>
> >> 3.14 also complains that it can't find an AGP bridge.  3.13 does not
> >> complain about that.
> >
> > CONFIG_GART_IOMMU is not defined for the 3.13.6-200.rc20.x86_64
> > kernel, but apparently it is for your v3.14-rc7 kernel.  That explains
> > the "No AGP bridge found" difference.
> >
> > I'm afraid I still can't shed any light on the problem with the radeon device.
> 
> Is there any news on this?  It would be a shame to release v3.14 with
> a known regression.
> 
> I opened https://bugzilla.kernel.org/show_bug.cgi?id=73041 as a place
> to archive the dmesg, etc.

I didn't see any resolution on this (and I haven't done anything with it
myself).  If this is still a problem, could it be the same as
https://bugzilla.kernel.org/show_bug.cgi?id=79701 ?  There's a fix for
79701 in linux-next as of 2014-09-16:

https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/hotplug-vga&id=b440bde74f043c8ec31081cb59c9a53ade954701

Bjorn
