Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3HOUpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:45:08 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:48027 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3HOUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:45:06 -0400
MIME-Version: 1.0
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AE89B41@HASMSX106.ger.corp.intel.com>
References: <CALCETrXmy1KwGUNbG0pgsbAt=mk27P3xd0ja4i9sPB6RhbcOeg@mail.gmail.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE89B41@HASMSX106.ger.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 15 Aug 2013 13:44:44 -0700
Message-ID: <CALCETrWVXnuLwSA1eENiAjdUF0-B09v77Th0_MUcNiFa5+B56A@mail.gmail.com>
Subject: Re: mei oopses at startup if it's built-in (3.11-rc5)
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 9:05 PM, Winkler, Tomas <tomas.winkler@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> Sent: Thursday, August 15, 2013 03:15
>> To: Winkler, Tomas; linux-kernel@vger.kernel.org
>> Subject: mei oopses at startup if it's built-in (3.11-rc5)
>>
>> It blows up early enough that it's awkward to get the whole oops, but it's in
>> the probe function.  If it's a module, I get instead:
>>
>> [   73.401679] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
>> [   73.401684] mei_me 0000:00:16.0: initialization failed.
>>
>> Let me know if I should debug further, but this may be obvious.
>
> I would ask you for pci config space dump
>

Like this?

00:16.0 Communication controller: Intel Corporation C600/X79 series
chipset MEI Controller #1 (rev 05)
        Subsystem: Super Micro Computer Inc Device 0724
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at dfa26000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
00: 86 80 3a 1d 06 00 10 00 05 00 80 07 00 00 80 00
10: 04 60 a2 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 24 07
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00
40: 45 03 0f 00 00 00 01 80 01 83 00 b9 00 00 00 00
50: 01 8c 03 c8 08 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 05 00 80 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 40
c0: ea 00 f4 be 33 80 f8 4a 0c 67 d0 6e aa 65 3f 86
d0: fc 7c a4 ed 29 28 1e 2e f0 a4 80 39 0f e0 6e a7
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:16.1 Communication controller: Intel Corporation C600/X79 series
chipset MEI Controller #2 (rev 05)
        Subsystem: Super Micro Computer Inc Device 0724
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 10
        Region 0: Memory at dfa25000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
00: 86 80 3b 1d 06 00 10 00 05 00 80 07 00 00 80 00
10: 04 50 a2 df 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 24 07
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 02 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 8c 03 c8 08 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 05 00 80 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 40
c0: ea 00 f4 be 33 80 f8 4a 0c 67 d0 6e aa 65 3f 86
d0: fc 7c a4 ed 29 28 1e 2e f0 a4 80 39 0f e0 6e a7
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

--Andy
