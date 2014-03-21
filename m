Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbaCUQiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:38:07 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:43846 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463AbaCUQiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:38:04 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVjHkdbe5N4iov-7dg6tGmuFsr70z2ASpX+=km=FMWe7Q@mail.gmail.com>
References: <CALCETrVG6uRysbXSbyPfKzG7uBHu9PX6SKvDbUQWG1TOfc04zQ@mail.gmail.com>
 <CADnq5_NJLsF4MmcQVN7jDD6-ZjAobw0bf2ft2HWGid6GMcXWcA@mail.gmail.com> <CALCETrVjHkdbe5N4iov-7dg6tGmuFsr70z2ASpX+=km=FMWe7Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 21 Mar 2014 10:37:41 -0600
Message-ID: <CAErSpo4J-rEkr-xDojZNTShRxoimUsYcFwrY-K4K3sZ3rporRw@mail.gmail.com>
Subject: Re: 3.14 radeon regression: radeon is broken (pci bug?)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 9:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Mar 21, 2014 at 7:41 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Thu, Mar 20, 2014 at 10:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> My system works on a 3.13 Fedora kernel.  It does not work on a
>>> more-or-less identically configured 3.14-rc7+ kernel.  The symptom is
>>> that the Plymouth password prompt flashes and them the screen goes
>>> blank.  Hitting escape brings back the text console, and all is well
>>> until X tries to start.  Then I get a blank screen.  killall -9 Xorg
>>> from ssh causes these errors to be logged:
>>>
>>>
>>> [  226.239747] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
>>> more than 5secs aborting
>>> [  226.239751] [drm:atom_execute_table_locked] *ERROR* atombios stuck
>>> executing CD34 (len 55, WS 0, PS 0) @ 0xCD57
>>> [  231.241492] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
>>> more than 5secs aborting
>>> [  231.241496] [drm:atom_execute_table_locked] *ERROR* atombios stuck
>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
>>> [  236.243111] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
>>> more than 5secs aborting
>>> [  236.243115] [drm:atom_execute_table_locked] *ERROR* atombios stuck
>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
>>> [  241.244625] [drm:atom_op_jump] *ERROR* atombios stuck in loop for
>>> more than 5secs aborting
>>> [  241.244628] [drm:atom_execute_table_locked] *ERROR* atombios stuck
>>> executing CD6C (len 62, WS 0, PS 0) @ 0xCD88
>>>
>>>
>>> lspci -vvvxxxnn on 3.14-rc7+ says:
>>>
>>> 09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
>>> [AMD/ATI] Caicos [Radeon HD 6450/7450/8450 / R5 230 OEM] [1002:6779]
>>> (rev ff) (prog-if ff)
>>>     !!! Unknown header type 7f
>>>     Kernel driver in use: radeon
>>> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>
>>> 09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
>>> Caicos HDMI Audio [Radeon HD 6400 Series] [1002:aa98] (rev ff)
>>> (prog-if ff)
>>>     !!! Unknown header type 7f
>>>     Kernel driver in use: snd_hda_intel
>>> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>
>>> (oops!)
>>>
>>> On 3.13, it says:
>>>
>>> 09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc.
>>> [AMD/ATI] Caicos [Radeon HD 6450/7450/8450 / R5 230 OEM] [1002:6779]
>>> (prog-if 00 [VGA controller])
>>>         Subsystem: PC Partner Limited / Sapphire Technology Radeon HD
>>> 6450 1 GB DDR3 [174b:e164]
>>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>         Latency: 0, Cache Line Size: 64 bytes
>>>         Interrupt: pin A routed to IRQ 92
>>>         Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
>>>         Region 2: Memory at f4a20000 (64-bit, non-prefetchable) [size=128K]
>>>         Region 4: I/O ports at c000 [size=256]
>>>         Expansion ROM at f4a00000 [disabled] [size=128K]
>>>         Capabilities: <access denied>
>>>         Kernel driver in use: radeon
>>> 00: 02 10 79 67 07 04 10 00 00 00 00 03 10 00 80 00
>>> 10: 0c 00 00 e0 00 00 00 00 04 00 a2 f4 00 00 00 00
>>> 20: 01 c0 00 00 00 00 00 00 00 00 00 00 4b 17 64 e1
>>> 30: 00 00 a0 f4 50 00 00 00 00 00 00 00 0a 01 00 00
>>>
>>> 09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI]
>>> Caicos HDMI Audio [Radeon HD 6400 Series] [1002:aa98]
>>>         Subsystem: PC Partner Limited / Sapphire Technology Radeon HD
>>> 6450 1GB DDR3 [174b:aa98]
>>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>>> ParErr- Stepping- SERR- FastB2B- DisINTx+
>>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>         Latency: 0, Cache Line Size: 64 bytes
>>>         Interrupt: pin B routed to IRQ 96
>>>         Region 0: Memory at f4a40000 (64-bit, non-prefetchable) [size=16K]
>>>         Capabilities: <access denied>
>>>         Kernel driver in use: snd_hda_intel
>>> 00: 02 10 98 aa 06 04 10 00 00 00 03 04 10 00 80 00
>>> 10: 04 00 a4 f4 00 00 00 00 00 00 00 00 00 00 00 00
>>> 20: 00 00 00 00 00 00 00 00 00 00 00 00 4b 17 98 aa
>>> 30: 00 00 00 00 50 00 00 00 00 00 00 00 05 02 00 00
>>>
>>> Logs attached.

Hi Andy,

I'm really sorry that you tripped over this, but thanks a lot for the
report.  Is there any chance the box is currently running v3.13, and
you could collect the dmesg log from it?  I don't see anything unusual
from a PCI perspective in the v3.14-rc7 dmesg; all the PCI device
resources look fine, and we didn't reassign anything.  It seems like
the 0000:09:00.x devices just stopped responding for some reason, and
the PCI core shouldn't really be involved after the radeon driver
claims and enables those devices.  But it's possible I'd get a clue by
comparing the v3.13 and v3.14-rc7 dmesg logs.

Bjorn
