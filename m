Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaLRLFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:05:42 -0500
Received: from lists.s-osg.org ([54.187.51.154]:40543 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaLRLFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:05:41 -0500
Date: Thu, 18 Dec 2014 09:05:36 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Aristeu Rozanski <aris@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Subject: Re: [LKP] [sb_edac] 50d1bb93672: EDAC sbridge: ECC is disabled.
 Aborting
Message-ID: <20141218090536.0d671dca@recife.lan>
In-Reply-To: <1418890406.26403.2.camel@intel.com>
References: <1418890406.26403.2.camel@intel.com>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

Em Thu, 18 Dec 2014 16:13:26 +0800
Huang Ying <ying.huang@intel.com> escreveu:

> FYI, we noticed the below changes on
> 
> commit 50d1bb93672fa2f42cec6e06ce799fbe864f57e9 ("sb_edac: add support for Haswell based systems")
> 
> Something new in kernel log.  This may be expected.  Just FYI.
> 
> [   12.490615] EDAC sbridge: Seeking for: PCI ID 8086:2fa0
> [   12.491031] EDAC sbridge: Seeking for: PCI ID 8086:2fa0
> [   12.491454] EDAC sbridge: Seeking for: PCI ID 8086:2ffc
> [   12.491865] EDAC sbridge: Seeking for: PCI ID 8086:2ffc
> [   12.492284] EDAC sbridge: Seeking for: PCI ID 8086:2ffd
> [   12.492698] EDAC sbridge: Seeking for: PCI ID 8086:2ffd
> [   12.493110] EDAC sbridge: Seeking for: PCI ID 8086:2f60
> [   12.493528] EDAC sbridge: Seeking for: PCI ID 8086:2fa8
> [   12.493943] EDAC sbridge: Seeking for: PCI ID 8086:2fa8
> [   12.494359] EDAC sbridge: Seeking for: PCI ID 8086:2f71
> [   12.494789] EDAC sbridge: Seeking for: PCI ID 8086:2f71
> [   12.495206] EDAC sbridge: Seeking for: PCI ID 8086:2faa
> [   12.495622] EDAC sbridge: Seeking for: PCI ID 8086:2faa
> [   12.496040] EDAC sbridge: Seeking for: PCI ID 8086:2fab
> [   12.496462] EDAC sbridge: Seeking for: PCI ID 8086:2fab
> [   12.496878] EDAC sbridge: Seeking for: PCI ID 8086:2fac
> [   12.497297] EDAC sbridge: Seeking for: PCI ID 8086:2fac
> [   12.497714] EDAC sbridge: Seeking for: PCI ID 8086:2fad
> [   12.497923] IOAPIC[0]: Set routing entry (8-22 -> 0xb3 -> IRQ 22 Mode:1 Active:1 Dest:1)
> [   12.497927] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B3 Dest:00000001 SID:F0FF SQ:0 SVT:1)
> [   12.497981] snd_hda_intel 0000:00:1b.0: irq 75 for MSI/MSI-X
> [   12.498086] IOAPIC[1]: Set routing entry (9-12 -> 0xe3 -> IRQ 36 Mode:1 Active:1 Dest:1)
> [   12.498089] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E3 Dest:00000001 SID:002C SQ:0 SVT:1)
> [   12.498093] snd_hda_intel 0000:02:00.1: Disabling MSI
> [   12.498109] snd_hda_intel 0000:02:00.1: Handle VGA-switcheroo audio client
> [   12.502542] EDAC sbridge: Seeking for: PCI ID 8086:2fad
> [   12.502956] EDAC sbridge: Seeking for: PCI ID 8086:2fbd
> [   12.503365] EDAC sbridge: Seeking for: PCI ID 8086:2f68
> [   12.503781] EDAC sbridge: Seeking for: PCI ID 8086:2f68
> [   12.504197] EDAC sbridge: Seeking for: PCI ID 8086:2f79
> [   12.504620] EDAC sbridge: Seeking for: PCI ID 8086:2f6a
> [   12.505041] EDAC sbridge: Seeking for: PCI ID 8086:2f6b
> [   12.505452] EDAC sbridge: Seeking for: PCI ID 8086:2f6c
> [   12.505869] EDAC sbridge: Seeking for: PCI ID 8086:2f6d
> [   12.506298] EDAC sbridge: ECC is disabled. Aborting
> [   12.506718] EDAC sbridge: Couldn't find mci handler

Not sure about what are you complaining, since you didn't show how was
the log before.

>From the above, what looks weird, from EDAC driver PoV, is:
	[   12.506298] EDAC sbridge: ECC is disabled. Aborting

Does it used to work before? If so, was there any BIOS setting change?
Does the memories used on this machine have ECC?

Regards,
Mauro

> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 
> Thanks,
> Huang, Ying
> 
