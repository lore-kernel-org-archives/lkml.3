Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaATXa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:30:57 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:37934 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaATXax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:30:53 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2014 18:30:53 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Jan 2014 00:22:53 +0100
From: Stefan Agner <stefan@agner.ch>
To: Jan Kara <jack@suse.cz>, John Twideldum <twideldums_throwaway@gmx.at>
Cc: linux-kernel@vger.kernel.org, linux-kernel-owner@vger.kernel.org,
        powertop@ml01.01.org
Subject: Re: 3.12-rc5 and overwritten partition table - by
 =?UTF-8?Q?powertop=3F?=
In-Reply-To: <20131029201032.GC9568@quack.suse.cz>
References: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
 <trinity-f65147f9-012f-4e78-a5a6-3f969ff5b9bf-1383058674646@3capp-gmx-bs07>
 <20131029201032.GC9568@quack.suse.cz>
Message-ID: <95f3d045b73e5fc326912975b24fec7f@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-10-29 21:10, schrieb Jan Kara:
>> The first ~170kb of /dev/sda got blown away with what seems to be a logging output
>> by Powertop, when I was playing with the tuneables.
>> (Luckily the first partition starts later :-))
>   So did you log the output to some file? I'm just trying to understand how
> it could get onto your disk in the first place...
> 
>> Why is that I don't know, but maybe when turning on the SATA knobs
>> something goes wrong. I'm afraid to try again, but I accept rather higher
>> power use than data loss again :-/

I experienced the same on the very same hardware (Lenovo T440s). Like
John, I turned all those knobs in powertop, including the SATA ones.
Several time I ended up with broken partition table. Once, even my EFI
System partition (first partition) was broken. However, since I use EFI
I was able to recover the partition table quite easily (gdisk asks for
recovery from backup partition table, kudos to the designer of the GPT
format!).

This happens running on Arch Linux with stock 3.12.7 as well as mainline
3.13 kernel. I use latest T440s firmware (2.17). 

Is it possible to disable/warn user when using that knob (at least on
Lenovo T440s), in order to avoid users left at an unbootable system...?

dmesg output:
[    2.744398] ata1: SATA max UDMA/133 abar m2048@0xf063c000 port
0xf063c100 irq 59
[    2.744400] ata2: DUMMY
[    2.744401] ata3: DUMMY
[    3.063804] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.064532] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[    3.064536] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    3.064538] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    3.064606] ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES)
succeeded
[    3.064926] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    3.064929] ata1.00: ATA-9: Samsung SSD 840 PRO Series, DXM05B0Q, max
UDMA/133
[    3.064931] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    3.065256] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[    3.065259] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    3.065261] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    3.065286] ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES)
succeeded
[    3.065545] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    3.065605] ata1.00: configured for UDMA/133
...
[  130.578789] ata1.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x40000
action 0x0
[  130.578794] ata1.00: irq_stat 0x40000001
[  130.578796] ata1: SError: { CommWake }
[  130.578798] ata1.00: failed command: WRITE FPDMA QUEUED
[  130.578802] ata1.00: cmd 61/10:00:f0:29:05/00:00:00:00:00/40 tag 0
ncq 8192 out
[  130.578804] ata1.00: status: { DRDY ERR }
[  130.578806] ata1.00: error: { ABRT }
...
[  130.579011] ata1.00: failed command: WRITE FPDMA QUEUED
[  130.579014] ata1.00: cmd 61/10:f0:58:7c:0f/00:00:00:00:00/40 tag 30
ncq 8192 out
[  130.579016] ata1.00: status: { DRDY ERR }
[  130.579017] ata1.00: error: { ABRT }
[  130.579207] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[  130.579456] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[  130.579511] ata1.00: configured for UDMA/133
[  130.579583] ata1: EH complete

--
Stefan
