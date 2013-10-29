Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3J2Wc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:32:28 -0400
Received: from mout.gmx.net ([212.227.15.15]:49293 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab3J2Wc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:32:27 -0400
MIME-Version: 1.0
Message-ID: <trinity-828f1d13-83b5-4778-8df7-adc560730362-1383085945942@3capp-gmx-bs31>
From: "John Twideldum" <twideldums_throwaway@gmx.at>
To: "Jan Kara" <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.12-rc5 and overwritten partition table - by powertop?
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Oct 2013 23:32:26 +0100 (CET)
Importance: normal
Sensitivity: Normal
In-Reply-To: <20131029222002.GD12814@quack.suse.cz>
References: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
 <trinity-f65147f9-012f-4e78-a5a6-3f969ff5b9bf-1383058674646@3capp-gmx-bs07>
 <20131029201032.GC9568@quack.suse.cz>
 <trinity-93870424-b236-4b3e-be8c-7af706430adc-1383083920353@3capp-gmx-bs31>,
 <20131029222002.GD12814@quack.suse.cz>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:AT3M6K001Jwen9cz6ML1iTMfmVhyLCYEMhm6LZ04kFT
 mxtGoW1XU3jFnDBbOjPvLjlL9zctEcELnzOOGKhC+3tw/8ToCf
 QYfK9PG3VOIoTakUcaAbR6N2tNVIsRvJFHxiSZUUsiDWcwwQm5
 QqubFlU+MWxqRvTxjrm6XO3KyvEpguZFm9PHpGOF6VP0qbT8jv
 7Sf20qWvoGUfB7zpYwwdIIvm6qy1J2sF8x7gpmxYEOICzjVxh/
 v48pZiTS5701JpN798bDuNNUofByAz9mEE+AZy30Px/gVgz4NN 16jawA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> The first ~170kb of /dev/sda got blown away with what seems to be a logging output
>> >> by Powertop, when I was playing with the tuneables.
>> >
>> >So did you log the output to some file? I'm just trying to understand how
>> >it could get onto your disk in the first place...
>>
>> Attached a dump of the first 1Mb of the disk, HTH.
>> It looks like a powertop log?
>> (I have powertop 2.4)
>
>Yes, likely. But it is strange the corruption doesn't even end at any
>sensible boundary (data ends at offset 0x27b53). Shrug...

My recollection what I did is this:

I was looking into powertop and observing how -rc5 works now with Haswell.
I saw the tuneable parameters and quite a few were "bad", so I set them to "good".
Power usage dropped about one third - yay!
However, changing "SATA link power" threw up complaints:

Oct 29 09:09:21 localhost kernel: [ 3697.423868] ata1.00: exception Emask 0x10 SAct 0x1 SErr 0xc0000 action 0x6 frozen
Oct 29 09:09:21 localhost kernel: [ 3697.423873] ata1.00: irq_stat 0x08000000, interface fatal error
Oct 29 09:09:21 localhost kernel: [ 3697.423877] ata1: SError: { CommWake 10B8B }
Oct 29 09:09:21 localhost kernel: [ 3697.423880] ata1.00: failed command: WRITE FPDMA QUEUED
Oct 29 09:09:21 localhost kernel: [ 3697.423886] ata1.00: cmd 61/38:00:01:9e:a4/01:00:00:00:00/40 tag 0 ncq 159744 out
Oct 29 09:09:21 localhost kernel: [ 3697.423886]          res 50/01:00:01:00:00/00:00:00:00:00/00 Emask 0x10 (ATA bus error)
Oct 29 09:09:21 localhost kernel: [ 3697.423888] ata1.00: status: { DRDY }
Oct 29 09:09:21 localhost kernel: [ 3697.423894] ata1: hard resetting link
Oct 29 09:09:22 localhost kernel: [ 3697.743196] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
Oct 29 09:09:22 localhost kernel: [ 3697.744707] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
Oct 29 09:09:22 localhost kernel: [ 3697.744719] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Oct 29 09:09:22 localhost kernel: [ 3697.744725] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Oct 29 09:09:22 localhost kernel: [ 3697.744813] ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES) succeeded
Oct 29 09:09:22 localhost kernel: [ 3697.745212] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
Oct 29 09:09:22 localhost kernel: [ 3697.746694] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
Oct 29 09:09:22 localhost kernel: [ 3697.746705] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Oct 29 09:09:22 localhost kernel: [ 3697.746711] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Oct 29 09:09:22 localhost kernel: [ 3697.746779] ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES) succeeded
Oct 29 09:09:22 localhost kernel: [ 3697.747286] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
Oct 29 09:09:22 localhost kernel: [ 3697.747432] ata1.00: configured for UDMA/133
Oct 29 09:09:22 localhost kernel: [ 3697.763181] ata1: EH complete

I did not know yet about what "frozen" means, so I did not investigate and
very soon powered down as I had to leave.
Next time I boot up.... I did not boot.
So data probable is just the size because as long as I had powertop running...

HTH,
J
