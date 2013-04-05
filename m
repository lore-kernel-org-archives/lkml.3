Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161550Ab3DEFH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:07:27 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49076 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3DEFH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:07:26 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Apr 2013 01:07:25 EDT
X-Originating-Ip: 216.16.235.2
Date: Fri, 5 Apr 2013 01:07:25 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: libata: how to duplicate the exact xfer_mask?
Message-ID: <20130405050725.GB27991@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using a 3.2.x kernel (Debian Wheezy, 3.2.41 with Debian patches),
on a Dell Inspiron 630m with an old TravelStar 12G IDE disk.

As the system boots I get:

[   46.880298] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[   46.880450] ata1.00: failed command: WRITE DMA
[   46.880552] ata1.00: cmd ca/00:08:00:08:00/00:00:00:00:00/e0 tag 0 dma 4096 o
ut
[   46.880556]          res 40/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeo
ut)
[   46.880834] ata1.00: status: { DRDY }
[   51.920181] ata1: link is slow to respond, please be patient (ready=0)
[   56.904182] ata1: device not ready (errno=-16), forcing hardreset
[   56.904270] ata1: soft resetting link
[   57.141036] ata1.00: configured for UDMA/66
[   57.141048] ata1.00: device reported invalid CHS sector 0
[   57.141063] ata1: EH complete


I get this three times, and then I get:


[  170.848292] ata1.00: limiting speed to UDMA/44:PIO4
[  170.848304] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  170.848453] ata1.00: failed command: WRITE DMA
[  170.848554] ata1.00: cmd ca/00:08:08:18:44/00:00:00:00:00/e0 tag 0 dma 4096 out
[  170.848558]          res 40/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
[  170.848835] ata1.00: status: { DRDY }
[  175.888174] ata1: link is slow to respond, please be patient (ready=0)
[  180.876182] ata1: device not ready (errno=-16), forcing hardreset
[  180.876272] ata1: soft resetting link
[  181.139230] ata1.00: configured for UDMA/44
[  181.139242] ata1.00: device reported invalid CHS sector 0
[  181.139257] ata1: EH complete


After this, the system works fine.

I'd like to duplicate these settings, so that it does not timeout, but
when I use:

	libata.force=ata1:udma/44,ata1:pio4

it continues to timeout as always, and goes through the same steps,
starting with UDMA/66 and landing on UDMA/44:PIO4.

What am I doing wrong?

Below is the dmesg identifying information.

Thanks,
- Chris



[    1.357523] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xbfa0 irq 14
[    1.357527] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xbfa8 irq 15
[    1.520652] ata2.00: ATAPI: _NEC DVD+/-RW ND-6650A, 102C, max UDMA/33
[    1.536274] ata2.00: configured for UDMA/33
[    1.540117] ata1.00: ATA-4: IBM-DARA-212000, AR4IA52A, max UDMA/66
[    1.540122] ata1.00: 23572080 sectors, multi 8: LBA 
[    1.540126] ata1.00: applying bridge limits
[    1.582858] ata1.00: configured for UDMA/66
[    1.582997] scsi 0:0:0:0: Direct-Access     ATA      IBM-DARA-212000  AR4I PQ: 0 ANSI: 5
[    1.584341] scsi 1:0:0:0: CD-ROM            _NEC     DVD+-RW ND-6650A 102C PQ: 0 ANSI: 5
[    1.588318] Refined TSC clocksource calibration: 1728.999 MHz.
[    1.588325] Switching to clocksource tsc
[    1.593291] sd 0:0:0:0: [sda] 23572080 512-byte logical blocks: (12.0 GB/11.2 GiB)
[    1.593353] sd 0:0:0:0: [sda] Write Protect is off
[    1.593357] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.593384] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

