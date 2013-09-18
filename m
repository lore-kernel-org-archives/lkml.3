Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3IRJBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:01:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:55914 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3IRJBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:01:48 -0400
Message-ID: <52396BF4.1050505@huawei.com>
Date: Wed, 18 Sep 2013 17:01:40 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: kexec: fast boot error in my hardware
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel is 3.4.24, and we changed it somewhere for the hardware.
When using kexec to fast boot a new kernel, Call Trace happens.
kernel_kexec()
	kernel_restart_prepare()
		blocking_notifier_call_chain()


Storage:~ # kexec -e
[  272.954064]  0000000000000000 00000000ffffffff ffff8800611a79c8 0000000000000004
[  272.962089]  ffff8800611a79a8 ffffffff814577e3 ffffffff81457760 ffff88006a027800
[  272.970057]  000000000000000a ffffffff8184f0a0 0000000000000030 0000000000000011
[  272.978028] Call Trace:
[  272.980623]  [<ffffffff81453a56>] ? _raw_spin_unlock+0x26/0x30
[  272.986593]  [<ffffffff8103b438>] ? vprintk+0x348/0x530
[  272.991963]  [<ffffffff8103b438>] ? vprintk+0x348/0x530
[  272.997327]  [<ffffffff8144fa54>] ? printk+0x3c/0x40
[  273.002427]  [<ffffffff8144fa54>] ? printk+0x3c/0x40
[  273.007532]  [<ffffffff8109d67d>] ? __module_text_address+0xd/0x70
[  273.013844]  [<ffffffff8109d6e9>] ? is_module_text_address+0x9/0x20
[  273.020245]  [<ffffffff81059ad8>] ? __kernel_text_address+0x58/0x80
[  273.026644]  [<ffffffff81059ad8>] ? __kernel_text_address+0x58/0x80
[  273.033045]  [<ffffffff81005841>] ? print_context_stack+0x81/0xe0
[  273.039269]  [<ffffffff810044e0>] ? dump_trace+0x100/0x2e0
[  273.044889]  [<ffffffff81005667>] show_trace_log_lvl+0x57/0x70
[  273.050854]  [<ffffffff810047e0>] show_stack_log_lvl+0x100/0x160
[  273.056991]  [<ffffffff81005607>] show_stack+0x17/0x20
[  273.062272]  [<ffffffffa0002138>] kbox_show_task_kernel_info+0xc8/0x300 [kbox]
[  273.069754]  [<ffffffffa0005547>] kbox_print_specified_tasks+0x47/0x50 [kbox]
[  273.077023]  [<ffffffffa000c003>] kbox_emerge_notifier_callback+0x153/0x1d0 [kbox]
[  273.084848]  [<ffffffff81062ea2>] ? __blocking_notifier_call_chain+0x42/0x80
[  273.092025]  [<ffffffff8145771f>] notifier_call_chain+0x3f/0x80
[  273.098078]  [<ffffffff81062eb8>] __blocking_notifier_call_chain+0x58/0x80
[  273.105082]  [<ffffffff81062ef1>] blocking_notifier_call_chain+0x11/0x20
[  273.111914]  [<ffffffff81052258>] kernel_restart_prepare+0x18/0x40
[  273.118226]  [<ffffffff810a481d>] kernel_kexec+0xcd/0x1d0
[  273.123761]  [<ffffffff810524ad>] sys_reboot+0x17d/0x220
[  273.129210]  [<ffffffff8116a4ce>] ? mntput+0x1e/0x30
[  273.134311]  [<ffffffff810034b0>] ? do_invalid_op+0x90/0xb0
[  273.140018]  [<ffffffff8116a4ce>] ? mntput+0x1e/0x30
[  273.145120]  [<ffffffff81233699>] ? lockdep_sys_exit_thunk+0x35/0x67
[  273.151604]  [<ffffffff8145b839>] system_call_fastpath+0x16/0x1b
[  273.157804] calling kbox_sync :begin
[  273.161520] sync kbox :begin
[  273.164541] open all redirect device :begin
[  273.168864] open all redirect device :end
[  273.173011] flush kbox regions :begin
[  273.176814] kbox region (emerge) is writing into (biosnvram), action is 202
[  273.183902] test write len : 1074
[  273.187356] first start addr : ffff88007e606000
[  273.192019] second start addr : ffff88007e626000
[  273.196770] cur_index : 8, offset : 131072, third start addr : ffff88007e626008
[  273.204326] first length : 1074
[  273.207607] bios_write_file_data write data len *ptr_length : 1074
[  273.213913] cur_index : 9, record_number : 9, total_number : 16
[  273.219968] kbox region (emerge) has been written into (biosnvram)
[  273.226278] dev biosnvram is dirty
[  273.229823] kbox region (console) is writing into (biosnvram), action is 202
[  273.236998] test write len : 3107
[  273.240448] first start addr : ffff88007e946000
[  273.245110] second start addr : ffff88007e992000
[  273.249858] cur_index : 19, offset : 311296, third start addr : ffff88007e992008
[  273.257500] first length : 3107
[  273.260786] bios_write_file_data write data len *ptr_length : 3107
[  273.267089] cur_index : 20, record_number : 20, total_number : 32
[  273.273313] kbox region (console) has been written into (biosnvram)
[  273.279708] dev biosnvram is dirty
[  273.283252] kbox region (message) is writing into (biosnvram), action is 202
[  273.290428] test write len : 16425
[  273.293967] first start addr : ffff88007e746000
[  273.298630] second start addr : ffff88007e876000
[  273.303379] cur_index : 19, offset : 1245184, third start addr : ffff88007e876008
[  273.311108] first length : 16425
[  273.314511] bios_write_file_data write data len *ptr_length : 16425
[  273.320903] cur_index : 20, record_number : 20, total_number : 32
[  273.327128] kbox region (message) has been written into (biosnvram)
[  273.333523] dev biosnvram is dirty
[  273.337068] flush kbox regions :end
[  273.340697] flush kbox superblock :begin
[  273.344759] supperblock dev=biosnvram is dirty
[  273.349341] flush kbox superblock: end
[  273.353227] close all redirect device :begin
[  273.357634] close all redirect device :end
[  273.361869] sync kbox :end
[  273.364718] calling kbox_sync :end
[  273.368480] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  273.376265] Starting new kernel
[  273.379560] os test 55555555555555555555555555555555555555555555555
[  273.385957] os test 666666666666666666666666666666666666666666666
[  273.392180] os test 77777777777777777777777777777777777777777777
[  273.398311] os test 88888888888888888888888888888888888888888888
[  273.404441] os test 99999999999999999999999999999999999999999999999
[  289.409856] [68438][5400040600ce][INF][Startup mode value=40][BSP][COM_Star.eQuery,362][os_sync_coffer]
[  289.426574] Extended CMOS year: 2000
[  289.430314] Extended CMOS year: 2000
[  289.434052] Extended CMOS year: 2000
[  289.437789] Extended CMOS year: 2000
[  289.441527] Extended CMOS year: 2000
[  289.445262] Extended CMOS year: 2000
[  289.448999] Extended CMOS year: 2000
[  289.452735] Extended CMOS year: 2000
[  289.456470] Extended CMOS year: 2000
[  289.460206] Extended CMOS year: 2000
[  289.463942] Extended CMOS year: 2000
[  289.489030] [68438][5400040607da][INF][Current bios channel is : [1].][BSP][SP5_GetB.ersion,1386][os_sync_coffer]
[  289.506582] [68438][5400040607e3][INF][SPV2R1 BIOS Date:2013-09-03.][BSP][SPV2R1_G.osDate,1544][os_sync_coffer]
[  289.531204] [68438][540004060117][INF][Boot id:ffffffff][BSP][SP2_Read.evName,1968][os_sync_coffer]
[  289.540498] [68438][5400040608d3][WAR][cBootId is invalid][BSP][SP2_Read.evName,1971][os_sync_coffer]
[  289.592881] [OS_COPY_FILE_FROM_PEER]copying file...
[  291.808692] [OS_COPY_FILE_FROM_PEER]copy file finish[1]...
[  291.819039] [OS_COPY_FILE_FROM_PEER]copy file from remote by lftp
[  291.837260] [os_sync_file.sh] sync file /OSM/coffer_log/log_secondary/cur_debug//messages fail. please view //lftp_return_9550
[  291.872094] [os_sync_cur_debug.sh] Warning!!! Target not exist, syncing to the second point.
[  291.911784]  the boot disk is /dev/sda
[  291.942090] link to peer is bad,can't save /tmp/cur_debug_26795/cur_debug to /OSM/coffer_log/log_secondary of 127.127.127.11.
[  291.958719] sync cur debug file fail

