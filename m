Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764733Ab3DDToK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:44:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46327 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764631Ab3DDToJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:44:09 -0400
Date: Thu, 4 Apr 2013 21:44:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Eric Valette <eric.valette@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Strange trace in dmesg on kernel 3.8.5
Message-ID: <20130404194404.GA8082@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Eric Valette <eric.valette@free.fr>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org
References: <515DD32F.3030509@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <515DD32F.3030509@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ linux-ide.

On Thu, Apr 04, 2013 at 09:23:27PM +0200, Eric Valette wrote:
> Hi,
> 
> When booting a brand new machine freshly installed I notice in the
> dmesg output always the same worrying trace:
> 
> PS copy me I'm not subscribed.
> 
> 
> ata2.00: ATA-9: Samsung SSD 840 Series, DXT07B0Q, max UDMA/133
> ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>   ------------[ cut here ]------------
> WARNING: at /usr/src/linux-3.8.5/lib/dma-debug.c:947
> check_for_stack+0x92/0xc7()
> Hardware name: System Product Name
> ahci 0000:00:1f.2: DMA-API: device driver maps memory fromstack
> [addr=ffff88040df2da50]
> Modules linked in:
> Pid: 1419, comm: scsi_eh_1 Not tainted 3.8.5 #3
> Call Trace:
>  [<ffffffff8121915c>] ? check_for_stack+0x92/0xc7
>  [<ffffffff8102bd25>] warn_slowpath_common+0x7c/0x94
>  [<ffffffff8102bd84>] warn_slowpath_fmt+0x47/0x49
>  [<ffffffff8121915c>] check_for_stack+0x92/0xc7
>  [<ffffffff8121927e>] debug_dma_map_sg+0xed/0x150
>  [<ffffffff8133fd72>] ata_qc_issue+0x22c/0x2e1
>  [<ffffffff81340061>] ata_exec_internal_sg+0x23a/0x42c
>  [<ffffffff813402d1>] ata_exec_internal+0x7e/0x8b
>  [<ffffffff813482cb>] ata_read_log_page+0x78/0x7f
>  [<ffffffff813414ea>] ata_dev_configure+0xcc1/0x112b
>  [<ffffffff81035b0d>] ? del_timer_sync+0x2b/0x49
>  [<ffffffff815341c1>] ? schedule_timeout+0x145/0x165
>  [<ffffffff8104c913>] ? wake_up_process+0x32/0x32
>  [<ffffffff815362ae>] ? _raw_spin_lock_irqsave+0x18/0x39
>  [<ffffffff8153642d>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
>  [<ffffffff81340228>] ? ata_exec_internal_sg+0x401/0x42c
>  [<ffffffff813402d1>] ? ata_exec_internal+0x7e/0x8b
>  [<ffffffff8134260a>] ? ata_std_postreset+0x9e/0xc4
>  [<ffffffff81340300>] ? ata_do_dev_read_id+0x22/0x24
>  [<ffffffff81340499>] ? ata_dev_read_id+0xd4/0x3f3
>  [<ffffffff8134ea61>] ? ahci_error_handler+0x3b/0x3b
>  [<ffffffff81347a63>] ? ata_ering_map+0x3a/0x5a
>  [<ffffffff8134a4f3>] ata_eh_recover+0x6b0/0xee2
>  [<ffffffff8134ea61>] ? ahci_error_handler+0x3b/0x3b
>  [<ffffffff8134ee52>] ? ahci_dev_classify+0x4d/0x4d
>  [<ffffffff8134f9e1>] ? ahci_do_softreset+0x177/0x177
>  [<ffffffff813426b0>] ? ata_phys_link_offline+0x27/0x27
>  [<ffffffff8134b417>] ata_do_eh+0x46/0x93
>  [<ffffffff813426b0>] ? ata_phys_link_offline+0x27/0x27
>  [<ffffffff8134f9e1>] ? ahci_do_softreset+0x177/0x177
>  [<ffffffff8134ee52>] ? ahci_dev_classify+0x4d/0x4d
>  [<ffffffff8134ea61>] ? ahci_error_handler+0x3b/0x3b
>  [<ffffffff8134ee52>] ? ahci_dev_classify+0x4d/0x4d
>  [<ffffffff8134b4b9>] ata_std_error_handler+0x55/0x5c
>  [<ffffffff8134ea49>] ahci_error_handler+0x23/0x3b
>  [<ffffffff8134affe>] ata_scsi_port_error_handler+0x236/0x554
>  [<ffffffff8134b3a8>] ata_scsi_error+0x8c/0xb5
>  [<ffffffff81329f8d>] scsi_error_handler+0xa3/0x40a
>  [<ffffffff8104c920>] ? default_wake_function+0xd/0xf
>  [<ffffffff81329eea>] ? scsi_eh_get_sense+0xa2/0xa2
>  [<ffffffff81042662>] kthread+0xb5/0xbd
>  [<ffffffff810425ad>] ? kthread_stop+0x53/0x53
>  [<ffffffff815370ac>] ret_from_fork+0x7c/0xb0
>  [<ffffffff810425ad>] ? kthread_stop+0x53/0x53
>   ---[ end trace b53ccdbc387522c5 ]---
> 
> --eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
