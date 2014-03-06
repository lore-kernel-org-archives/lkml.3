Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaCFSEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:04:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42513 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751190AbaCFSEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:04:51 -0500
Date: Thu, 6 Mar 2014 13:04:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Jones <davej@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, <dan.j.williams@intel.com>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: uhci_hcd: DMA-API: cpu touching an active dma mapped cacheline
In-Reply-To: <20140306030511.GA19653@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1403061258390.961-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Dave Jones wrote:

> WARNING: CPU: 3 PID: 25477 at lib/dma-debug.c:593 debug_dma_assert_idle+0x1ba/0x223()
> uhci_hcd 0000:00:1d.2: DMA-API: cpu touching an active dma mapped cacheline [cln=0x0000000002355f80]
> Modules linked in: fuse tun l2tp_ppp l2tp_netlink l2tp_core can_raw can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc hidp bluetooth 6lowpan_iphc can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 p8022 psnap llc ax25 cfg80211 rfkill nouveau video backlight mxm_wmi wmi i2c_algo_bit ttm drm_kms_helper drm tg3 i2c_core ptp pps_core libphy kvm_intel kvm lpc_ich microcode pcspkr mfd_core parport_pc serio_raw parport shpchp rtc_cmos xfs libcrc32c raid0 floppy
> CPU: 3 PID: 25477 Comm: cc Not tainted 3.14.0-rc5+ #2 
> Hardware name: Dell Inc.                 Precision WorkStation 490    /0DT031, BIOS A08 04/25/2008
>  00000000 2e7036e5 00000000 db851dbc c15f76ee db851dfc db851dec c1043733
>  c17ce4b0 db851e1c 00006385 c17ccc7a 00000251 c130a152 c130a152 eef3f650
>  efb53480 00000000 db851e08 c1043788 00000009 db851dfc c17ce4b0 db851e1c
> Call Trace:
>  [<c15f76ee>] dump_stack+0x4b/0x75
>  [<c1043733>] warn_slowpath_common+0x7e/0x95
>  [<c130a152>] ? debug_dma_assert_idle+0x1ba/0x223
>  [<c130a152>] ? debug_dma_assert_idle+0x1ba/0x223
>  [<c1043788>] warn_slowpath_fmt+0x3e/0x51
>  [<c130a152>] debug_dma_assert_idle+0x1ba/0x223
>  [<c1159704>] do_wp_page+0x108/0x8a1
>  [<c115b790>] ? handle_mm_fault+0x1ba/0xd54
>  [<c15ff7ea>] ? _raw_spin_lock+0x6b/0x72
>  [<c115bae2>] handle_mm_fault+0x50c/0xd54
>  [<c160357c>] ? __do_page_fault+0xee/0x55c
>  [<c16035da>] __do_page_fault+0x14c/0x55c
>  [<c16039ea>] ? __do_page_fault+0x55c/0x55c
>  [<c16039f7>] do_page_fault+0xd/0xf
>  [<c1600dfc>] error_code+0x6c/0x74
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 25490 at lib/dma-debug.c:593 debug_dma_assert_idle+0x1ba/0x223()
> uhci_hcd 0000:00:1d.2: DMA-API: cpu touching an active dma mapped cacheline [cln=0x0000000002355f80]
> ---[ end trace 3ac75acf24cf0b9e ]---
> Mapped at:
>  [<c13081b5>] debug_dma_alloc_coherent+0x2b/0xc3
> Modules linked in: fuse tun l2tp_ppp l2tp_netlink l2tp_core can_raw can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc hidp bluetooth 6lowpan_iphc can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 p8022 psnap llc ax25 cfg80211 rfkill nouveau video backlight mxm_wmi wmi i2c_algo_bit ttm drm_kms_helper drm tg3 i2c_core ptp pps_core libphy kvm_intel kvm lpc_ich microcode pcspkr mfd_core parport_pc serio_raw parport shpchp rtc_cmos xfs libcrc32c raid0 floppy
>  
> [<c116fcee>] dma_pool_alloc+0x14f/0x2fd
>  [<c1456eaa>] uhci_alloc_td.isra.35+0x24/0x60
>  [<c1457fa6>] uhci_start+0x272/0x56b
>  [<c142d8fb>] usb_add_hcd+0x252/0x774
> 
> CPU: 3 PID: 25490 Comm: cc Tainted: G        W    3.14.0-rc5+ #2 
> Hardware name: Dell Inc.                 Precision WorkStation 490    /0DT031, BIOS A08 04/25/2008
>  00000000 bf79585b 00000000 db81bdbc c15f76ee db81bdfc db81bdec c1043733
>  c17ce4b0 db81be1c 00006392 c17ccc7a 00000251 c130a152 c130a152 eef3f650
>  efb53480 00000000 db81be08 c1043788 00000009 db81bdfc c17ce4b0 db81be1c
> Call Trace:
>  [<c15f76ee>] dump_stack+0x4b/0x75
>  [<c1043733>] warn_slowpath_common+0x7e/0x95
>  [<c130a152>] ? debug_dma_assert_idle+0x1ba/0x223
>  [<c130a152>] ? debug_dma_assert_idle+0x1ba/0x223
>  [<c1043788>] warn_slowpath_fmt+0x3e/0x51
>  [<c130a152>] debug_dma_assert_idle+0x1ba/0x223
>  [<c1159704>] do_wp_page+0x108/0x8a1
>  [<c115b790>] ? handle_mm_fault+0x1ba/0xd54
>  [<c15ff7ea>] ? _raw_spin_lock+0x6b/0x72
>  [<c115bae2>] handle_mm_fault+0x50c/0xd54
>  [<c160357c>] ? __do_page_fault+0xee/0x55c
>  [<c16035da>] __do_page_fault+0x14c/0x55c
>  [<c1603683>] ? __do_page_fault+0x1f5/0x55c
>  [<c160065b>] ? restore_all+0xf/0xf
>  [<c12f0d89>] ? __put_user_4+0x11/0x18
>  [<c16039ea>] ? __do_page_fault+0x55c/0x55c
>  [<c16039f7>] do_page_fault+0xd/0xf
>  [<c1600dfc>] error_code+0x6c/0x74
> ---[ end trace 3ac75acf24cf0b9f ]---
> Mapped at:
>  [<c13081b5>] debug_dma_alloc_coherent+0x2b/0xc3
>  [<c116fcee>] dma_pool_alloc+0x14f/0x2fd
>  [<c1456eaa>] uhci_alloc_td.isra.35+0x24/0x60
>  [<c1457fa6>] uhci_start+0x272/0x56b
>  [<c142d8fb>] usb_add_hcd+0x252/0x774

I don't get it.  As the name indicates, debug_dma_alloc_coherent should 
give us consistent memory -- meaning that the CPU is allowed to access 
the memory while DMA is in progress, without worrying about caching 
effects (see Documentation/DMA-API.txt).

So why should we get a warning when the CPU accesses this memory?  Is 
this a regression in the DMA debug library?

Alan Stern

