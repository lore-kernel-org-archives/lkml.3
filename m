Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaCaUuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:50:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:36625 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaCaUuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:50:11 -0400
Date: Mon, 31 Mar 2014 22:50:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yijing Wang <wangyijing@huawei.com>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Zhangwei <jovi.zhangwei@huawei.com>
Subject: Re: [BUGREPORT] Tasklet scheduled issue in Linux 3.4.x-rt
In-Reply-To: <53144A57.4040204@huawei.com>
Message-ID: <alpine.DEB.2.02.1403312230340.14882@ionos.tec.linutronix.de>
References: <53144A57.4040204@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014, Yijing Wang wrote:

> Hi list,
>    I found a tasklet related issue in linux-stable-rt 3.4.
> 
> And after I revert following commit, the test result seems ok(test lasted 40hours).
> 
> commit 0d9f73fc1e7270a3f8709c59c913408153d9d9f8

This commit id does not exist in the official stable rt tree.

> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Nov 29 20:18:22 2011 -0500
> 
>     tasklet: Prevent tasklets from going into infinite spin in RT
 
> 
> I test FC driver IO in this kernel, and after a few hours test, FC IO will abort, I found a lot of tasklet WARNING Call Trace in kernel message,like:
> 
> [2012-03-26 18:55:43][  929.252289] ------------[ cut here ]------------
> [2012-03-26 18:55:43][  929.252312] WARNING: at kernel/softirq.c:773 __tasklet_action+0x51/0x1a0()

There is no warning at line 773 in any official linux-stable-rt 3.4.

> [2012-03-26 18:55:43][  929.252314] Hardware name: Romley
> [2012-03-26 18:55:43][  929.252316] Modules linked in: isd_fid(O) ivs_edft(O) ivs_emp(O) ivs_xnet(O) isd_rds(O) isd_idm(O) isd_dft(O) isd_base(O) sdm(O) isd_cmm(O) isd_ibc(O) isd_lib(O) xve_hab(PO) xve_net(PO) xve_cls_msg_filter(PO) xve_dscp(PO) pagepool(PO) iod(O) cmm(PO) util(PO) intel_t10(PO) itest_nid(PO) dmi(PO) bsp_adapter(PO) mpa(O) ipmi_si ipmi_devintf ipmi_msghandler iscsi_sw(PO) iscsi_prot(O) iscsi_seg(PO) iscsi_comm(PO) iscsi_initiator(PO) 8192cu(O) pciehp(PO) pcieaer(PO) pciecore(PO) drvinstallthird(PO) quark(O) sal(O) pmsas(O) foe(O) lfcoe(O) libfc(O) ib_uverbs(O) ibtgt(O) ib_srpt(O) ib_cm(O) ib_sa(O) mlx4_ib(O) ib_umad(O) ib_mad(O) mlx4_core(O) ib_core(O) drvtom(O) cxgb4(O) drvtoecore(O) fcdrv(PO) unflowlevel(PO) unfcommon(O) drvmml(PO) scsi_transport_fc scsi_tgt memtest(PO) drv_iosubsys_ini(O) iocount(O) bsp_mml(PO) agetty_query(PO) cpufreq_powersave af_packet nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_limit xt_tcpudp xt_multiport nf_conntr!
> ack_ipv4
>  nf_defrag_ipv4 xt_state nf_conntrack usr_cache(O) acpi_cpufreq mperf processor thermal_sys sg hwmon iptable_filter ip_tables x_tables ixgbe(O) igb(O) bonding(O) tg(O) netmgmt(O) drvinstall(PO) dal(PO) dca usb_storage(O) uhci_hcd ehci_hcd usbcore(O) usb_common sata_mml(O) ahci(O) libata(O) satahp(O) drvframe(PO) sd_mod crc_t10dif scsi_mod agetty_interface(PO) ext3 jbd mbcache nvram_printk(PO) os_feeddog(PO) os_debug(O) osp_proc(PO) os_rnvramdev(PO) vos(O) bsp(PO) os_die_handler(O) os_oom_handler(O) os_panic_handler(O) biosnvramdriver(O) kbox(O)
> [2012-03-26 18:55:43][  929.252460] Pid: 17495, comm: 3th SioT Tainted: P           O 3.4.24.15-0.11-default #1

You have loaded a gazillion of proprietary and out of tree modules and
your kernel is tainted 'P'.

None of our problems. See:

 http://lwn.net/1999/0211/a/lt-binary.html

 https://lwn.net/Articles/287056/

I'm in a good mood today and give you some hints:

- Ingos patch is correct and always has been for RT.

- We had not a single bug report against this in almost 10 years.

- File your bugs to those who abuse our work and violate our license.

Case closed.

     tglx
