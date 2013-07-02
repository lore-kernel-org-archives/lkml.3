Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3GBH24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 03:28:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64967 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3GBH2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 03:28:51 -0400
Message-ID: <51D2811F.5090305@huawei.com>
Date: Tue, 2 Jul 2013 15:28:31 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <wick.wei@huawei.com>, Xishi Qiu <qiuxishi@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [REPORT] oops occured in rcu_do_batch
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After running for nearly one year, oops occured. 

rcu_process_callbacks
	__rcu_process_callbacks
		rcu_do_batch
			list->func(list)

It seems that the function pointer "list->func(list)" in rcu_do_batch was NULL when 
the oops occured. But I can not reproduce the oops.The kernel version:linux-2.6.32.12-0.7

<1>BUG: unable to handle kernel NULL pointer dereference at (null)
<1>IP: [<(null)>] (null)
<4>PGD 24f18067 PUD 49bd0067 PMD 0 
<0>Oops: 0010 [#1] SMP 
<0>last sysfs file: /sys/devices/pci0000:ff/0000:ff:02.3/irq
<0>
<0>< < < < < < < < < < < < < Oops Reboot [cmostime: 1372060283: jiffies: 6454921036] > > > > > > > > > >> > >
<1>Not found BSP_PrintDevTemperatureVoltage
<4>CPU 1 
<4>Modules linked in: agetty_query(PN) ommml(PN) iat(PN) disk_doctor(PN) osp_sys(PN) scm_kernel(PN) smartcache(PN) ps(PN) disk_fault(PN) upgrade_k(PN) tp(PN) fcopy(PN) rm_async(PN) rm_sync(PN) rm_arena(PN) hyperclone(PN) osp_cpy(PN) epl(PN) snapshot(PN) bgr(PN) rpr(PN) inimp(PN) rsf(PN) diskmp(PN) hmp(PN) cache(PN) dynamic(PN) lunex(PN) raid0(PN) raid6(PN) raid50(PN) raid10(PN) raid3(PN) raid(PN) bd_agent(PN) dha_agent(PN) alm_agent(N) iscsi_target(N) iscsi_initiator(N) tgtscsi(PN) nvram(PN) pcieibs(N) bmp_k(PN) bs(N) mtgt(PN) vault(PN) asyncibc(PN) mdb(PN) drv_dha(PN) hima_emp(PN) disk_adapt(PN) ioframework(N) perf_kernel(PN) lic_kernel(PN) aa_db(PN) alarm_client(PN) db_mgr(PN) db_krn(PN) cmm(PN) msys(N) econf(PN) gem_client(PN) ibc_k(PN) msg_converter(PN) msg_client(PN) config_select(PN) pciehp(N) pcieaer(N) pciebase(N) pmsas(N) switch(N) ixgbe(N) igb(N) dev(N) fcdrv(PN) fceventhandle(PN) drvmml(PN) bsp_mml(PN) osp_ea(PN) himassp(PN) compress(PN) omdc_k(PN) cpufreq_powersa!
ve(N) ac
pi_cpufreq(N) processor(N) thermal_sys(N) nf_conntrack_ipv6(N) ip6table_filter(N) ip6_tables(N) xt_limit(N) xt_tcpudp(N) xt_multiport(N) nf_conntrack_ipv4(N) nf_defrag_ipv4(N) xt_state(N) nf_conntrack(N) iptable_filter(N) ip_tables(N) x_tables(N) bonding(N) i2c_core(N) e1000e(X) netmgmt(N) dca(N) ext3(N) jbd(N) mbcache(N) usbmon(N) usb_storage(N) ehci_hcd(N) usbcore(N) ata_piix(N) libata(N) sd_mod(N) crc_t10dif(N) scsi_mod(N) drvapi(N) rtc_cmos(N) rtc_core(N) rtc_lib(N) os_feeddog(PN) os_mem(PN) os_debug(PN) os_test(PN) os_hotpatch(PN) os_exportfun(PN) os_monitor(PN) osp_proc(PN) os_rnvramdev(PN) os_sys_gpl(N) vos(PN) bsp(N) [last unloaded: updatesas]
<4>Supported: Yes, External
<6>Pid: 20205, comm: ps Tainted: P          NX 2.6.32.12-0.7-default #1 Foxhollow platform
<6>RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
<6>RSP: 0018:ffff880028245ea8  EFLAGS: 00010202
<6>RAX: 0000000000000003 RBX: 0000000000000004 RCX: ffff88004adadbc0
<6>RDX: 0000000000000005 RSI: ffff88005ddb6588 RDI: ffff88004adadbc0
<6>RBP: ffff880028245ee0 R08: 0000000000000001 R09: 0000000000000001
<6>R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
<6>R13: ffff880028251e40 R14: ffff880036c038c0 R15: ffff880028251e70
<6>FS:  00007f448a49c6f0(0000) GS:ffff880028240000(0000) knlGS:0000000000000000
<6>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<6>CR2: 0000000000000000 CR3: 0000000027c40000 CR4: 00000000000006e0
<6>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<6>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process ps (pid: 20205, threadinfo ffff88006585e000, task ffff880024a9e400)
<0>Stack:
<4> ffffffff8109fd94 ffffffff8181c280 0000000000000001 0000000000000048
<4><0> 0000000000000009 0000000000000100 ffff88006585ffd8 ffff880028245ef0
<4><0> ffffffff8109ffe6 ffff880028245f40 ffffffff8104db56 0000000000011320
<0>Call Trace:
<0>Inexact backtrace:
<0>
<0> <IRQ> 
<4> [<ffffffff8109fd94>] ? __rcu_process_callbacks+0xf4/0x320
<4> [<ffffffff8109ffe6>] rcu_process_callbacks+0x26/0x50
<4> [<ffffffff8104db56>] __do_softirq+0xb6/0x160
<4> [<ffffffff81003fdc>] call_softirq+0x1c/0x30
<4> [<ffffffff81005a5a>] do_softirq+0x4a/0x80
<4> [<ffffffff8104da97>] irq_exit+0x77/0x80
<4> [<ffffffff8101a32c>] smp_apic_timer_interrupt+0x6c/0xa0
<4> [<ffffffff81003993>] apic_timer_interrupt+0x13/0x20
<0> <EOI> 
<4> [<ffffffff811c085d>] ? copy_user_generic_string+0x2d/0x40
<4> [<ffffffff81109d48>] ? seq_read+0x2c8/0x390
<4> [<ffffffff810ee344>] ? vfs_read+0xc4/0x190
<4> [<ffffffff810ee820>] ? sys_read+0x50/0x90
<4> [<ffffffff81002e7b>] ? system_call_fastpath+0x16/0x1b
<0>Code:  Bad RIP value.

Here is the config:
Storage:/ # zcat /proc/config.gz | grep RCU
# RCU Subsystem
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set


