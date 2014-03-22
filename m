Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaCVPSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 11:18:32 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:61238 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaCVPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 11:18:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4J-rEkr-xDojZNTShRxoimUsYcFwrY-K4K3sZ3rporRw@mail.gmail.com>
References: <CALCETrVG6uRysbXSbyPfKzG7uBHu9PX6SKvDbUQWG1TOfc04zQ@mail.gmail.com>
 <CADnq5_NJLsF4MmcQVN7jDD6-ZjAobw0bf2ft2HWGid6GMcXWcA@mail.gmail.com>
 <CALCETrVjHkdbe5N4iov-7dg6tGmuFsr70z2ASpX+=km=FMWe7Q@mail.gmail.com> <CAErSpo4J-rEkr-xDojZNTShRxoimUsYcFwrY-K4K3sZ3rporRw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 22 Mar 2014 08:18:07 -0700
Message-ID: <CALCETrVtfvBu0=2hofkSfh-ohrnUCS18yE4N0UYg7kqjJYBp1g@mail.gmail.com>
Subject: Re: 3.14 radeon regression: radeon is broken (pci bug?)
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e013a04f2a8038904f53383ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013a04f2a8038904f53383ed
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Mar 21, 2014 at 9:37 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Mar 21, 2014 at 9:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Fri, Mar 21, 2014 at 7:41 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>> On Thu, Mar 20, 2014 at 10:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> My system works on a 3.13 Fedora kernel.  It does not work on a
>>>> more-or-less identically configured 3.14-rc7+ kernel.  The symptom is
>>>> that the Plymouth password prompt flashes and them the screen goes
>>>> blank.  Hitting escape brings back the text console, and all is well
>>>> until X tries to start.  Then I get a blank screen.  killall -9 Xorg
>>>> from ssh causes these errors to be logged:
>>>>
>>>>
>>>> [  226.239747] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
>>>> more than 5secs aborting
>>>> [  226.239751] [drm:atom_execute_table_locked] *ERROR* atombios stuck
>>>> executing CD34 (len 55, WS 0, PS 0) @ 0xCD57
>>>> [  231.241492] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
>>>> more than 5secs aborting
>>>> [  231.241496] [drm:atom_execute_table_locked] *ERROR* atombios stuck
>>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
>>>> [  236.243111] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
>>>> more than 5secs aborting
>>>> [  236.243115] [drm:atom_execute_table_locked] *ERROR* atombios stuck
>>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
>>>> [  241.244625] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
>>>> more than 5secs aborting
>>>> [  241.244628] [drm:atom_execute_table_locked] *ERROR* atombios stuck
>>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
>>>>
>>>>
>>>> lspci -vvvxxxnn on 3.14-rc7+ says:
>>>>
>>>> 09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
>>>> [AMD/ATI] Caicos [Radeon HD 6450/7450/8450 / R5 230 OEM] [1002:6779]
>>>> (rev ff) (prog-if ff)
>>>>     !!! Unknown header type 7f
>>>>     Kernel driver in use: radeon
>>>> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>
>>>> 09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
>>>> Caicos HDMI Audio [Radeon HD 6400 Series] [1002:aa98] (rev ff)
>>>> (prog-if ff)
>>>>     !!! Unknown header type 7f
>>>>     Kernel driver in use: snd_hda_intel
>>>> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>
>>>> (oops!)
>>>>
>>>> On 3.13, it says:
>>>>
>>>> 09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
>>>> [AMD/ATI] Caicos [Radeon HD 6450/7450/8450 / R5 230 OEM] [1002:6779]
>>>> (prog-if 00 [VGA controller])
>>>>         Subsystem: PC Partner Limited / Sapphire Technology Radeon HD
>>>> 6450 1 GB DDR3 [174b:e164]
>>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Interrupt: pin A routed to IRQ 92
>>>>         Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
>>>>         Region 2: Memory at f4a20000 (64-bit, non-prefetchable) [size=128K]
>>>>         Region 4: I/O ports at c000 [size=256]
>>>>         Expansion ROM at f4a00000 [disabled] [size=128K]
>>>>         Capabilities: <access denied>
>>>>         Kernel driver in use: radeon
>>>> 00: 02 10 79 67 07 04 10 00 00 00 00 03 10 00 80 00
>>>> 10: 0c 00 00 e0 00 00 00 00 04 00 a2 f4 00 00 00 00
>>>> 20: 01 c0 00 00 00 00 00 00 00 00 00 00 4b 17 64 e1
>>>> 30: 00 00 a0 f4 50 00 00 00 00 00 00 00 0a 01 00 00
>>>>
>>>> 09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
>>>> Caicos HDMI Audio [Radeon HD 6400 Series] [1002:aa98]
>>>>         Subsystem: PC Partner Limited / Sapphire Technology Radeon HD
>>>> 6450 1GB DDR3 [174b:aa98]
>>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>         Latency: 0, Cache Line Size: 64 bytes
>>>>         Interrupt: pin B routed to IRQ 96
>>>>         Region 0: Memory at f4a40000 (64-bit, non-prefetchable) [size=16K]
>>>>         Capabilities: <access denied>
>>>>         Kernel driver in use: snd_hda_intel
>>>> 00: 02 10 98 aa 06 04 10 00 00 00 03 04 10 00 80 00
>>>> 10: 04 00 a4 f4 00 00 00 00 00 00 00 00 00 00 00 00
>>>> 20: 00 00 00 00 00 00 00 00 00 00 00 00 4b 17 98 aa
>>>> 30: 00 00 00 00 50 00 00 00 00 00 00 00 05 02 00 00
>>>>
>>>> Logs attached.
>
> Hi Andy,
>
> I'm really sorry that you tripped over this, but thanks a lot for the
> report.  Is there any chance the box is currently running v3.13, and
> you could collect the dmesg log from it?  I don't see anything unusual
> from a PCI perspective in the v3.14-rc7 dmesg; all the PCI device
> resources look fine, and we didn't reassign anything.  It seems like
> the 0000:09:00.x devices just stopped responding for some reason, and
> the PCI core shouldn't really be involved after the radeon driver
> claims and enables those devices.  But it's possible I'd get a clue by
> comparing the v3.13 and v3.14-rc7 dmesg logs.

Attached.  I also clearly screwed something up about my 3.14 config --
I meant for it to match the Fedora config, but it doesn't.  At least
NR_CPUs is too low.  That shoudn't break radeon, but maybe something
odd happens.

3.14 also complains that it can't find an AGP bridge.  3.13 does not
complain about that.

--Andy

--089e013a04f2a8038904f53383ed
Content-Type: application/x-xz; name="dmesg_3.13.txt.xz"
Content-Disposition: attachment; filename="dmesg_3.13.txt.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ht31jsip0

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
--089e013a04f2a8038904f53383ed--
