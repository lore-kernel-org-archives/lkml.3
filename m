Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaI1PTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 11:19:55 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:48783 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaI1PTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 11:19:54 -0400
Date: Sun, 28 Sep 2014 11:19:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-ide@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Fix controllers with no ctl port
Message-ID: <20140928151950.GA6072@mtj.dyndns.org>
References: <1411769086-12408-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411769086-12408-1-git-send-email-linux@rainbow-software.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 12:04:46AM +0200, Ondrej Zary wrote:
> Currently, ata_sff_softreset is skipped for controllers with no ctl port.
> But that also skips ata_sff_dev_classify required for device detection.
> This means that libata is currently broken on controllers with no ctl port.
> 
> No device connected:
> [    1.872480] pata_isapnp 01:01.02: activated
> [    1.889823] scsi2 : pata_isapnp
> [    1.890109] ata3: PATA max PIO0 cmd 0x1e8 ctl 0x0 irq 11
> [    6.888110] ata3.01: qc timeout (cmd 0xec)
> [    6.888179] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
> [   16.888085] ata3.01: qc timeout (cmd 0xec)
> [   16.888147] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
> [   46.888086] ata3.01: qc timeout (cmd 0xec)
> [   46.888148] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
> [   51.888100] ata3.00: qc timeout (cmd 0xec)
> [   51.888160] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> [   61.888079] ata3.00: qc timeout (cmd 0xec)
> [   61.888141] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> [   91.888089] ata3.00: qc timeout (cmd 0xec)
> [   91.888152] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> 
> ATAPI device connected:
> [    1.882061] pata_isapnp 01:01.02: activated
> [    1.893430] scsi2 : pata_isapnp
> [    1.893719] ata3: PATA max PIO0 cmd 0x1e8 ctl 0x0 irq 11
> [    6.892107] ata3.01: qc timeout (cmd 0xec)
> [    6.892171] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
> [   16.892079] ata3.01: qc timeout (cmd 0xec)
> [   16.892138] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
> [   46.892079] ata3.01: qc timeout (cmd 0xec)
> [   46.892138] ata3.01: failed to IDENTIFY (I/O error, err_mask=0x5)
> [   46.908586] ata3.00: ATAPI: ACER CD-767E/O, V1.5X, max PIO2, CDB intr
> [   46.924570] ata3.00: configured for PIO0 (device error ignored)
> [   46.926295] scsi 2:0:0:0: CD-ROM            ACER     CD-767E/O        1.5X PQ: 0 ANSI: 5
> [   46.984519] sr0: scsi3-mmc drive: 6x/6x xa/form2 tray
> [   46.984592] cdrom: Uniform CD-ROM driver Revision: 3.20
> 
> So don't skip ata_sff_softreset, just skip the reset part of ata_bus_softreset
> if the ctl port is not available.
> 
> This makes IDE port on ES968 behave correctly:
> 
> No device connected:
> [    4.670888] pata_isapnp 01:01.02: activated
> [    4.673207] scsi host2: pata_isapnp
> [    4.673675] ata3: PATA max PIO0 cmd 0x1e8 ctl 0x0 irq 11
> [    7.081840] Adding 2541652k swap on /dev/sda2.  Priority:-1 extents:1 across:2541652k
> 
> ATAPI device connected:
> [    4.704362] pata_isapnp 01:01.02: activated
> [    4.706620] scsi host2: pata_isapnp
> [    4.706877] ata3: PATA max PIO0 cmd 0x1e8 ctl 0x0 irq 11
> [    4.872782] ata3.00: ATAPI: ACER CD-767E/O, V1.5X, max PIO2, CDB intr
> [    4.888673] ata3.00: configured for PIO0 (device error ignored)
> [    4.893984] scsi 2:0:0:0: CD-ROM            ACER     CD-767E/O        1.5X PQ: 0 ANSI: 5
> [    7.015578] Adding 2541652k swap on /dev/sda2.  Priority:-1 extents:1 across:2541652k
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Applied to libata/for-3.18 w/ stable cc'd.

Thanks.

-- 
tejun
