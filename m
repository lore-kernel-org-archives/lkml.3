Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161909AbaKNUgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:36:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbaKNUgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:36:53 -0500
Date: Fri, 14 Nov 2014 21:36:42 +0100
From: Borislav Petkov <bp@suse.de>
To: Vinson Lee <vlee@twopensource.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Suresh Siddha <sbsiddha@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 math_error warning in Linux kernel 3.10
Message-ID: <20141114203641.GB7825@pd.tnic>
References: <CAHTgTXX=0JqGx1eYa4+Y5TuvzUpVwMNQdPe2a7m=r3pZBfGXxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHTgTXX=0JqGx1eYa4+Y5TuvzUpVwMNQdPe2a7m=r3pZBfGXxQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 12:19:16PM -0800, Vinson Lee wrote:
> Hi.
> 
> We hit this x86 math_error warning in Linux kernel 3.10.
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/include/asm/fpu-internal.h:524 math_error+0xd1/0x219()
> Modules linked in: cls_basic act_mirred cls_u32 veth sch_ingress
> netconsole configfs ipv6 dm_multipath scsi_dh video sbs sbshc hed
> acpi_pad acpi_ipmi acpi_i2c parport_pc lp parport tcp_diag inet_diag
> ipmi_si ipmi_devintf ipmi_msghandler dell_rbu sg iTCO_wdt
> iTCO_vendor_support dcdbas igb i2c_algo_bit ptp pps_core shpchp
> lpc_ich i2c_i801 mfd_core i2c_core ioatdma dca i7core_edac edac_core
> microcode freq_table mperf ahci libahci libata sd_mod scsi_mod
> CPU: 2 PID: 53182 Comm: java Not tainted 3.10.50 #1
>  0000000000000000 ffff8808e1f5be38 ffffffff8146cb74 ffff8808e1f5be70
>  ffffffff8103cbf9 0000000000000000 ffff88090b2c9730 ffff8808e1f5bf58
>  0000000000000010 0000000000000000 ffff8808e1f5be80 ffffffff8103ccbf
> Call Trace:
>  [<ffffffff8146cb74>] dump_stack+0x19/0x1b
>  [<ffffffff8103cbf9>] warn_slowpath_common+0x65/0x7d
>  [<ffffffff8103ccbf>] warn_slowpath_null+0x1a/0x1c
>  [<ffffffff8100317b>] math_error+0xd1/0x219
>  [<ffffffff81007f6c>] ? read_tsc+0x9/0x19
>  [<ffffffff8107bab8>] ? timekeeping_get_ns.constprop.10+0x11/0x36
>  [<ffffffff8107bf32>] ? ktime_get+0x68/0x76
>  [<ffffffff81007f6c>] ? read_tsc+0x9/0x19
>  [<ffffffff8107bab8>] ? timekeeping_get_ns.constprop.10+0x11/0x36
>  [<ffffffff810032d6>] do_coprocessor_error+0x13/0x15
>  [<ffffffff81478a38>] coprocessor_error+0x18/0x20
> ---[ end trace 3e4a6532a67ba6d3 ]---

AFAICT, you're getting an FPU exception for a task which hasn't used the
FPU or current is somehow pointing to the wrong task.

Can you trigger this with the latest kernel too, i.e., say, 3.18-rc4?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
