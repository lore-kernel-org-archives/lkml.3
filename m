Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3JLG4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:56:38 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:40336 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3JLG4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130928131059.GA3945@htj.dyndns.org>
References: <1380366816-16221-1-git-send-email-yxlraid@gmail.com>
	<20130928114950.GA2620@htj.dyndns.org>
	<CAP0P+NUvaLfXkOUGm8NX19AHvTHmU=Ya0NdFvyJc2gFjN-Cy0A@mail.gmail.com>
	<20130928131059.GA3945@htj.dyndns.org>
Date: Sat, 12 Oct 2013 14:56:34 +0800
Message-ID: <CAP0P+NXD7pdXQwBUZJdUwyCc=o_5iTzmKJ6FdN6LrqcgX3yK2A@mail.gmail.com>
Subject: Re: [PATCH 1/1] AHCI: disabled FBS prior to issuing software reset
From: xiangliang yu <yxlraid@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> On Sat, Sep 28, 2013 at 09:04:15PM +0800, xiangliang yu wrote:
>> hi, Tejun
>> i had tested the patch with Marvell 88se9235. And driver can find disk
>> if FBS disabled, or can't find disk.
>
> So it can't find the disk if FBS stays enabled?  Can you please attach
> the boot log before & after?

Below is boot log:

ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
ata_eh_revalidate_and_attach: dev->class = 5.
ata8.15: Port Multiplier 1.2, 0x1b4b:0x9715 r160, 5 ports, feat 0x1/0x1f
ahci 0000:03:00.0: FBS is enabled
ata8.00: hard resetting link
ata8.00: SATA link down (SStatus 0 SControl 330)
ata8.01: hard resetting link
ata8.01: SATA link down (SStatus 0 SControl 330)
ata8.02: hard resetting link
ata8.02: SATA link down (SStatus 0 SControl 330)
ata8.03: hard resetting link
ata8.03: SATA link up 6.0 Gbps (SStatus 133 SControl 133)
ata8.04: hard resetting link
ata8.04: failed to resume link (SControl 133)
ata8.04: failed to read SCR 0 (Emask=0x40)
ata8.04: failed to read SCR 0 (Emask=0x40)
ata8.04: failed to read SCR 1 (Emask=0x40)
ata8.04: failed to read SCR 0 (Emask=0x40)
ata_eh_revalidate_and_attach: dev->class = 1.
ata8.03: native sectors (2) is smaller than sectors (976773168)
ata8.03: ATA-8: ST3500413AS, JC4B, max UDMA/133
ata8.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata8.03: configured for UDMA/133
ata_eh_revalidate_and_attach: dev->class = 1.
ata8.04: failed to IDENTIFY (I/O error, err_mask=0x100)
ata8.15: hard resetting link
ata8.15: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
ata8.15: PMP revalidation failed (errno=-19)
ata8.15: hard resetting link
ata8.15: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
ata8.15: PMP revalidation failed (errno=-19)
ata8.15: limiting SATA link speed to 3.0 Gbps
ata8.15: hard resetting link
ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
ata8.15: PMP revalidation failed (errno=-19)
ata8.15: failed to recover PMP after 5 tries, giving up
ata8.15: Port Multiplier detaching
ata8.03: disabled
ata8.00: disabled
ata8: EH complete
