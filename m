Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3CTOq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:46:58 -0400
Received: from jonshouse.co.uk ([91.84.151.33]:37995 "EHLO
	mail.jonshouse.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3CTOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:46:57 -0400
Subject: 9 sata channels, 6 drives, two failing disks or controllers - no
 fucking idea how to tie the names together
From: jon <jon@jonshouse.co.uk>
Reply-To: jon@jonshouse.co.uk
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Mar 2013 14:46:55 +0000
Message-ID: <1363790815.9408.7.camel@jonspc>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess somebody noticed the kernel was too user friendly so you people
have "improved" the kernel again.

The in good old days kernel messages said things like /dev/sda bla bla 

Now I get :

[ 4706.176816] ata10: exception Emask 0x10 SAct 0x0 SErr 0x910000 action 0xe frozen
[ 4706.176827] ata9: exception Emask 0x10 SAct 0x0 SErr 0x990000 action 0xe frozen
[ 4706.176833] ata9: irq_stat 0x00400000, PHY RDY changed
[ 4706.176839] ata9: SError: { PHYRdyChg 10B8B Dispar LinkSeq }
[ 4706.176850] ata9: hard resetting link
[ 4706.193481] ata10: irq_stat 0x00400000, PHY RDY changed
[ 4706.197875] ata10: SError: { PHYRdyChg Dispar LinkSeq }
[ 4706.202104] ata10: hard resetting link
[ 4711.288030] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 4711.289538] ata10.00: configured for UDMA/133
[ 4711.289547] ata10: EH complete
[ 4711.320032] ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 4711.323494] ata9.00: configured for UDMA/33
[ 4711.323503] ata9: EH complete
[ 4775.368201] ata9: exception Emask 0x10 SAct 0x0 SErr 0x990000 action 0xe frozen
[ 4775.372501] ata9: irq_stat 0x00400000, PHY RDY changed
[ 4775.376792] ata9: SError: { PHYRdyChg 10B8B Dispar LinkSeq }
[ 4775.380948] ata9: hard resetting link
[ 4780.524032] ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 4780.536659] ata9.00: configured for UDMA/33
[ 4780.536667] ata9: EH complete

With these disks.
root@mail:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdd1             226G  3.9G  211G   2% /
tmpfs                1009M     0 1009M   0% /lib/init/rw
udev                 1004M  212K 1004M   1% /dev
tmpfs                1009M     0 1009M   0% /dev/shm
/dev/sde1             688G  336G  318G  52% /disks/vol1
/dev/sdf              2.7T  1.7T  879G  67% /disks/vol2
/dev/sdg              2.7T  1.8T  802G  70% /disks/vol3
/dev/sdb              2.7T  112G  2.5T   5% /disks/vol4
/dev/sdc1             1.4T  1.3T  2.4G 100% /disks/vol5
/dev/sda1             1.4T  1.2T  154G  89% /disks/vol6


Why when the kernel has the ATA=/dev/sdX can it not just tell the fucking users !



