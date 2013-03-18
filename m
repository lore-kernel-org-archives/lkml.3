Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3CRWuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:50:11 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39190 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3CRWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:50:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1303182304320.9529@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org>
	<1460519.ejNFI1DrGk@vostro.rjw.lan>
	<1363280764.26318.4.camel@thor.lan>
	<5657408.cYX6iimiA4@vostro.rjw.lan>
	<alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
	<5142E7F0.4020002@gmail.com>
	<alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
	<alpine.LNX.2.00.1303151609480.9529@pobox.suse.cz>
	<CAE9FiQUqPTUqPOzANnxpdfoRYPr+OiU5pFEoLKRiOFHd9Py4XQ@mail.gmail.com>
	<alpine.LNX.2.00.1303181010080.9529@pobox.suse.cz>
	<CAE9FiQXj0oD7_Abhz305dGytwg9_VKeEVuX128VXxEKexyvTLg@mail.gmail.com>
	<alpine.LNX.2.00.1303182304320.9529@pobox.suse.cz>
Date: Mon, 18 Mar 2013 15:50:06 -0700
X-Google-Sender-Auth: xzjbx8FDa_N6A78mbiX3OIgPdfg
Message-ID: <CAE9FiQVhrJov=it3Q5EB5fTJwA7tKQwScKSDfb_LgFE7_dEBkA@mail.gmail.com>
Subject: Re: [3.9-rc1] irq 16: nobody cared (was [3.9-rc1] very poor interrupt responses)
From: Yinghai Lu <yinghai@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 3:05 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 18 Mar 2013, Yinghai Lu wrote:
>
>> > Yes, switching from MSI to IO-APIC-fasteoi makes the report about lost
>> > interrupts go away.
>> >
>> > My understanding from the other mail is that DAniel Vetter already has an
>> > idea what might be going wrong with IRQ acking on GM45 chipsets; hopefully
>> > this datapoint regarding MSI will fit into it.
>>
>> What is /proc/interrupts difference between with and without pci=nomsi ?
>>
>> drm is forced to share irq 16?
>
> Yup, IRQ 16 is being shared, and one of the owners is i915.

the vga report strange INTx status...

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA
controller])
	Subsystem: Lenovo Device 20e4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at f2000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0100c  Data: 4142
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915
	Kernel modules: i915

it should be INTx-, after we have set DisINTx+ in control.

So INTx can not be disabled after it get enabled before ?

the VGA on my T420 looks right.

00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09) (prog-if
00 [VGA controller])
	Subsystem: Lenovo Device 21ce
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

Thanks

Yinghai
