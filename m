Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3DPGUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:20:08 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37444 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3DPGUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:20:05 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v9] irq: add quirk for broken interrupt remapping on 55XX chipsets
Date: Tue, 16 Apr 2013 08:20:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.6-dirty; KDE/4.10.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com> <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304160820.01484.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 of April 2013, Neil Horman wrote:
> A few years back intel published a spec update:
> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chi
> pset-ioh-specification-update.pdf
> 
> For the 5520 and 5500 chipsets which contained an errata (specificially
> errata 53), which noted that these chipsets can't properly do interrupt
> remapping, and as a result the recommend that interrupt remapping be
> disabled in bios.  While many vendors have a bios update to do exactly
> that, not all do, and of course not all users update their bios to a level
> that corrects the problem.  As a result, occasionally interrupts can
> arrive at a cpu even after affinity for that interrupt has be moved,
> leading to lost or spurrious interrupts (usually characterized by the
> message:
> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
> 
> There have been several incidents recently of people seeing this error, and
> investigation has shown that they have system for which their BIOS level is
> such that this feature was not properly turned off.  As such, it would be
> good to give them a reminder that their systems are vulnurable to this
> problem.  For details of those that reported the problem, please see:
> https://bugzilla.redhat.com/show_bug.cgi?id=887006

Tested-by: Arkadiusz Miśkiewicz <arekm@maven.pl>

(on top of 3.7.10 kernel)

Stack trace looks useless for me in this case but according changelog this was 
already discussed.

[    0.137512] Freeing SMP alternatives: 20k freed
[    0.143539] ACPI: Core revision 20120913
[    0.156067] dmar: Host address width 40
[    0.160440] dmar: DRHD base: 0x000000fe710000 flags: 0x1
[    0.166467] dmar: IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 
c90780106f0462 ecap f020f7
[    0.175618] dmar: RMRR base: 0x0000008f62f000 end: 0x0000008f631fff
[    0.182705] dmar: RMRR base: 0x0000008f61a000 end: 0x0000008f61afff
[    0.189792] dmar: RMRR base: 0x0000008f617000 end: 0x0000008f617fff
[    0.196871] dmar: RMRR base: 0x0000008f614000 end: 0x0000008f614fff
[    0.203960] dmar: RMRR base: 0x0000008f611000 end: 0x0000008f611fff
[    0.211047] dmar: RMRR base: 0x0000008f60e000 end: 0x0000008f60efff
[    0.218135] dmar: RMRR base: 0x0000008f60b000 end: 0x0000008f60bfff
[    0.225222] dmar: RMRR base: 0x0000008f608000 end: 0x0000008f608fff
[    0.232309] dmar: RMRR base: 0x0000008f605000 end: 0x0000008f605fff
[    0.239388] dmar: ATSR flags: 0x0
[    0.243273] ------------[ cut here ]------------
[    0.248515] WARNING: at 
/home/users/arekm/rpm/BUILD/kernel-3.7.10/linux-3.7/drivers/iommu/intel_irq_remapping.c:518 
intel_irq_remapping_supported+0x37/0x7
a()
[    0.264358] Hardware name: S5500WB
[    0.268238] This system BIOS has enabled interrupt remapping
on a chipset that contains an erratum making that
feature unstable.  To maintain system stability
interrupt remapping is being disabled.  Please
contact your BIOS vendor for an update
[    0.298811] Modules linked in:
[    0.302373] Pid: 1, comm: swapper/0 xid: #0 Not tainted 3.7.10-6 #1
[    0.309453] Call Trace:
[    0.312270]  [<ffffffff8105182a>] warn_slowpath_common+0x7a/0xb0
[    0.319061]  [<ffffffff810518ba>] warn_slowpath_fmt_taint+0x3a/0x40
[    0.326143]  [<ffffffff818e8371>] intel_irq_remapping_supported+0x37/0x7a
[    0.333810]  [<ffffffff813b7226>] irq_remapping_supported+0x26/0x30
[    0.340893]  [<ffffffff818bd1be>] enable_IR+0x9/0x3e
[    0.346521]  [<ffffffff818bd558>] enable_IR_x2apic+0xa0/0x1e3
[    0.353024]  [<ffffffff814cfdc4>] ? set_cpu_sibling_map+0x415/0x435
[    0.360108]  [<ffffffff818bf47a>] default_setup_apic_routing+0x12/0x6b
[    0.367483]  [<ffffffff818bb30b>] native_smp_prepare_cpus+0x2e7/0x336
[    0.374761]  [<ffffffff818abcd5>] kernel_init_freeable+0x89/0x1c4
[    0.381652]  [<ffffffff814b9380>] ? rest_init+0x70/0x70
[    0.387570]  [<ffffffff814b9389>] kernel_init+0x9/0x100
[    0.393489]  [<ffffffff814e8d7c>] ret_from_fork+0x7c/0xb0
[    0.399602]  [<ffffffff814b9380>] ? rest_init+0x70/0x70
[    0.405524] ---[ end trace bf40f410b44b3726 ]---
[    0.410830] Switched APIC routing to physical flat.
[    0.416872] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.456602] smpboot: CPU0: Intel(R) Xeon(R) CPU           X5560  @ 2.80GHz 
(fam: 06, model: 1a, stepping: 04)
[    0.573650] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, 
Intel PMU driver.
[    0.583265] perf_event_intel: CPU erratum AAJ80 worked around


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
