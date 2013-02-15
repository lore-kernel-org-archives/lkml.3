Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739Ab3BOQ06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:26:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3BOQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:26:57 -0500
Date: Fri, 15 Feb 2013 11:26:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: gavin.bowe@oracle.com, kurt.hackel@oracle.com
Subject: What went in Linux 3.6, 3.7 and 3.8 from Xen standpoint.
Message-ID: <20130215162651.GB13775@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I realized I hadn't done my usual 'here is what goes in' for about half-a-year.

So catching up and doing it all at once.

v3.6:
 - Fix a lot of bugs: Systems with MP BIOS failing, Systems with ACPI NUMA failing,
   FLR in xen-pciback leaving the devices unusable, 32-bit PCI sounds cards in dom0
   not working, fix crashes when using acpidump, fix crashes with CONFIG_MAX_DOMAIN_PAGES=512
 - Make the P2M interaction on MMIO ranges use less memory during booting
   (aka, Reuse existing P2M leafs).
 - Simplification and cleanups in the code base. Coverity fixes
 - Performance optimizations by caching TLS and GDT descriptors
 - Performance optimizations in PTE page manipulations
 - Xen MCE driver added (to see MCE events that Xen hypervisor gets)
 - Xen PCPU driver added (to online/offline physical CPUs via dom0)

v3.7:
 - Initial support for ARM working under Xen as both guest and initial domain.
 - Security fixes.
 - Fix RCU warning, add fallback code for old hypervisors, fix memory leaks in
   gntdev driver, fix some pvops calls failing, Fixes in
   xen-[kbd|fb|blk|net|hvc]-backend to deal with CLOSED transition
 - Allow xen/privcmd to use v2 of MMAPBATCH command (and fixes for it)
 - Support Xen backends to work with paged out grants (meaning work with HVM
   guests that have its memory paged out)
 - Performance optimization in xen/privcmd for migrating guests.
 - Performance improvements when doing kdump for PVonHVM guests.
 - Xen DBGP driver added (USB EHCI debug driver)
 - FLR support in xen-pciback.
 - Support wildcards in xen-pciback.hide=(*) argument parsing.
 - Xen EFI support, and keyboard shift status flag.
 - Late usage of Xen-SWIOTLB allowing PV PCI passthrough guest to boot without
   'iommu=soft' as an argument and late initialization of SWIOTLB.
 - Support more than 128GB in a PV guest.
 - Cleanups in the initial pagetable creation.

v3.8:
 - Persistent feature grant in xen-block system allowing greater performance.
 - More fixes in the Xen-pciback for wildcard parsing
 - Xen Processor Aggregator Device (PAD) added.
 - Optimizations for xen/privcmd for ARM and PVH via new hypercall (add_to_physmap_range)
 - Xen ARM can use the balloon driver
 - Fixes for vcpu onlining/offlining, grant table initialization, parsing of cpu
   onlining/offlining values, checks in xen-pciback, locking fixes in gtndev,
   fix stack corruptions, fix xen_iret checks. xen-pciback DoSing dom0 with
   messages, fix mmap batch ioctl error path.
 - Further enh to allow PVHVM backend drivers (so moving dom0 functionality in guests)
