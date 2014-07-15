Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbaGOIO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:14:58 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60179 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbaGOIOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:14:55 -0400
Message-ID: <53C4E2F0.8000307@linux.vnet.ibm.com>
Date: Tue, 15 Jul 2014 16:14:40 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mlombard@redhat.com, ming.lei@canonical.com, dongsu.park@profitbricks.com,
        jet.chen@intel.com, viro@zeniv.linux.org.uk, hch@lst.de,
        kmo@daterainc.com, axboe@kernel.dk, akpm@linux-foundation.org,
        axboe@fb.com
Subject: Bug_ON with patch: bio: modify __bio_add_page() to accept pages that
 don't start a new segment
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071508-8256-0000-0000-00000E7E6EBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Power7 box boot fail with commit:

254c4407cb84a6dec90336054615b0f0e996bb7c
bio: modify __bio_add_page() to accept pages that don't start a new segment

Just revert it will works for me.

See below:

[   22.659431] ------------[ cut here ]------------
[   22.659437] kernel BUG at fs/direct-io.c:747!
[   22.659501] Oops: Exception in kernel mode, sig: 5 [#1]
[   22.659528] SMP NR_CPUS=1024 NUMA PowerNV
[   22.659533] Modules linked in: e1000e vhost_net tun ses(+) macvtap 
macvlan enclosure ptp pps_core vhost be2net(+) shpchp kvm binfmt_misc 
uinput lpfc scsi_transport_fc ipr
[   22.659688] CPU: 8 PID: 772 Comm: lvm Not tainted 
3.16.0-rc5-next-20140714+ #76
[   22.659755] task: c0000003b0a7dc20 ti: c0000003b0afc000 task.ti: 
c0000003b0afc000
[   22.659823] NIP: c0000000002ba854 LR: c0000000002bad80 CTR: 
0000000000000010
[   22.659890] REGS: c0000003b0aff450 TRAP: 0700   Not tainted 
(3.16.0-rc5-next-20140714+)
[   22.659957] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI> CR: 
24222844  XER: 20000000
[   22.660114] CFAR: c0000000002bad90 SOFTE: 1
GPR00: c0000000002bad80 c0000003b0aff6d0 c00000000145c148 0000000000000000
GPR04: 0000000000000000 0000000000000000 c000000000b6e7c8 0000000000000001
GPR08: 0000000000000000 0000000000010000 0000000000100000 f000000000000000
GPR12: 0000000024222844 c00000000fee2400 0000000000000010 c0000003b9140000
GPR16: 0000000000010000 c0000003b9140000 0000000000047bff 0000000000010000
GPR20: 0000000000000000 f000000000cb0fdc 0000000000010000 0000000000010000
GPR24: 0000000000000000 0000000000010000 0000000000000000 c0000003b0afc000
GPR28: 0000000000000000 00000000023dff80 c0000003fcb10380 c0000003b9140028
[   22.660980] NIP [c0000000002ba854] .__blockdev_direct_IO+0x1584/0x3960
[   22.661036] LR [c0000000002bad80] .__blockdev_direct_IO+0x1ab0/0x3960
[   22.661092] Call Trace:
[   22.661116] [c0000003b0aff6d0] [c0000000002bad80] 
.__blockdev_direct_IO+0x1ab0/0x3960 (unreliable)
[   22.661208] [c0000003b0aff980] [c0000000002b6114] 
.blkdev_direct_IO+0x64/0x80
[   22.661276] [c0000003b0affa20] [c0000000001dd430] 
.generic_file_read_iter+0x5b0/0x690
[   22.661355] [c0000003b0affb50] [c0000000002b5a40] 
.blkdev_read_iter+0x60/0x90
[   22.661423] [c0000003b0affbd0] [c000000000269d28] 
.new_sync_read+0xa8/0x120
[   22.661491] [c0000003b0affcf0] [c00000000026b280] .vfs_read+0xc0/0x1f0
[   22.661559] [c0000003b0affd90] [c00000000026b674] .SyS_read+0x64/0x110
[   22.661628] [c0000003b0affe30] [c00000000000a158] syscall_exit+0x0/0x98
[   22.661695] Instruction dump:
[   22.661729] e88100d8 80a100e4 80c100e0 f92100c0 39200000 912100a8 
4814fe15 60000000
[   22.661841] 812100e4 78630020 7f891800 419ef880 <0fe00000> 60000000 
60420000 e9410118
[   22.661955] ---[ end trace 6248a5bb36020fd2 ]---

Thanks,
Mike




