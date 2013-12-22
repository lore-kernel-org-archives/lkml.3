Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3LVFhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 00:37:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3LVFhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 00:37:14 -0500
Message-ID: <1387690631.5412.58.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: muli.baron@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Sun, 22 Dec 2013 06:37:11 +0100
In-Reply-To: <1387689024.5412.49.camel@marge.simpson.net>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
	 <20131220154146.GA18672@breakpoint.cc>
	 <1387617104.30230.7.camel@marge.simpson.net> <52B5CE09.5030908@gmail.com>
	 <1387685830.5412.37.camel@marge.simpson.net>
	 <1387689024.5412.49.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:B2iLV4niLxajk8WytHXK1xzqStY8MWEaFhnfxIATM4E
 ytQm0zH6+95RM7/qrGozkKuonRYmdaakIVN7cZI9aT/vt2Ocls
 8FwZbS+JrmzHGa+mamBZUNguFneWzqsMUWU4kjKhBPp4T7l+Wr
 wrRWrOGuRLOF9LONhdIkoVa3+rrfYBgvH7d9sGB7cdNTB+o7Pa
 IF7qPPYzDuHdAVg4Jvwn1KJvQ8ZS5QRlwtChTQpmxpfwcFMquP
 Ntz6xJ2Z7ORpvFKOawbw5FL6oAdisYEtYFxIFdVd69/IGCFE26
 2YsPOQ3NdHXnZ26na8Tb7rzit6XTqEctLTf3+BdRA9CUrAzQoI
 88TI6aRJoM2wS1jNoTK0ccx96LExgCwPf0udwMKVYogXcjUt9+
 HAdD9NfMzSjkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-22 at 06:10 +0100, Mike Galbraith wrote:

> DL980 with same rt7 patchset/config, but with nohz_full=55-63 can take a
> while to make up its mind, but does kick in (this boot anyway).

While rebuilding with distro config (lard=max, but nohz_full=off)...

[ 2230.960596] ------------[ cut here ]------------
[ 2231.008947] WARNING: CPU: 24 PID: 372 at kernel/time/tick-sched.c:161 can_stop_full_tick+0x1b3/0x1c0()
[ 2231.136916] Modules linked in: nfsv3 nfs_acl nfs fscache lockd sunrpc autofs4 edd af_packet bridge stp llc cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq fuse loop ipmi_si iTCO_wdt iTCO_vendor_support gpio_ich sg sr_mod cdrom joydev ipmi_msghandler netxen_nic bnx2 i7core_edac lpc_ich mfd_core edac_core acpi_power_meter pcspkr button ext3 jbd radeon ttm drm_kms_helper drm i2c_algo_bit thermal processor thermal_sys scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh ata_generic ata_piix hpsa cciss
[ 2231.633825] CPU: 24 PID: 372 Comm: ksoftirqd/24 Not tainted 3.12.6-rt7 #189
[ 2231.633827] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[ 2231.633831]  00000000ffffffff ffff88027459bbf8 ffffffff81573a2d ffffffff810b8583
[ 2231.633833]  00000000000000a1 ffff88027459bc38 ffffffff8104fe1c ffff88027459bc28
[ 2231.633834]  ffff88027710be40 ffff880277100000 0000000000000002 0000000000000000
[ 2231.633835] Call Trace:
[ 2231.633854]  [<ffffffff81573a2d>] dump_stack+0x4d/0xa8
[ 2231.633863]  [<ffffffff810b8583>] ? can_stop_full_tick+0x1b3/0x1c0
[ 2231.633872]  [<ffffffff8104fe1c>] warn_slowpath_common+0x8c/0xc0
[ 2231.633928]  [<ffffffff8104fe6a>] warn_slowpath_null+0x1a/0x20
[ 2231.633929]  [<ffffffff810b8583>] can_stop_full_tick+0x1b3/0x1c0
[ 2231.633931]  [<ffffffff810b8625>] __tick_nohz_full_check+0x95/0xb0
[ 2231.633933]  [<ffffffff810b864e>] nohz_full_kick_work_func+0xe/0x10
[ 2231.633941]  [<ffffffff8110a0a9>] __irq_work_run+0x69/0x80
[ 2231.633943]  [<ffffffff8110a0c9>] irq_work_run+0x9/0x10
[ 2231.633946]  [<ffffffff8105e1f4>] run_timer_softirq+0x24/0x2d0
[ 2231.633955]  [<ffffffff8108a2a5>] ? sched_clock_cpu+0xc5/0x110
[ 2231.633958]  [<ffffffff8108afc5>] ? account_system_time+0x175/0x1a0
[ 2231.633964]  [<ffffffff810560c6>] handle_softirq+0xa6/0x180
[ 2231.633966]  [<ffffffff810562f8>] do_current_softirqs+0x158/0x230
[ 2231.633968]  [<ffffffff81056403>] run_ksoftirqd+0x33/0x50
[ 2231.633971]  [<ffffffff8107ee82>] smpboot_thread_fn+0x232/0x360
[ 2231.633973]  [<ffffffff8107ec50>] ? smpboot_create_threads+0x80/0x80
[ 2231.633977]  [<ffffffff8107571e>] kthread+0xbe/0xd0
[ 2231.633978]  [<ffffffff81075660>] ? kthreadd+0x1d0/0x1d0
[ 2231.633988]  [<ffffffff8157fb2c>] ret_from_fork+0x7c/0xb0
[ 2231.633990]  [<ffffffff81075660>] ? kthreadd+0x1d0/0x1d0
[ 2231.633992] ---[ end trace 0000000000000002 ]---


