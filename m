Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3HWUaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:30:55 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58136 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755161Ab3HWUay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:30:54 -0400
Date: Fri, 23 Aug 2013 15:30:50 -0500
From: Russ Anderson <rja@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, Tejun Heo <tj@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
Message-ID: <20130823203050.GB31817@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130822202158.GD3490@mtj.dyndns.org> <1377205598.10300.715.camel@misato.fc.hp.com> <20130822212111.GF3490@mtj.dyndns.org> <1377209861.10300.756.camel@misato.fc.hp.com> <20130823130440.GC10322@mtj.dyndns.org> <1377274448.10300.777.camel@misato.fc.hp.com> <521793BB.9080605@gmail.com> <CAE9FiQXZ610BrVaXoxY70NS3CaSku7mcVFx+x34-jpYUkG2rdQ@mail.gmail.com> <201308231825.r7NIPQl5015165@mail.zytor.com> <CAE9FiQVxQtpHp+0b1zFaA4YHx6hDiNSHKDveU=FzS5LwR80RmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVxQtpHp+0b1zFaA4YHx6hDiNSHKDveU=FzS5LwR80RmA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 01:08:56PM -0700, Yinghai Lu wrote:
> On Fri, Aug 23, 2013 at 11:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > BRK makes sense as long as you can set a sane O(1) size limit.
> >
> >>
> >>put the acpi override table in BRK, we still need ok from HPA.
> >>I have impression that he did not like it, so want to confirm from him.
> 
> on 8 sockets system:
> -rw-r--r-- 1 root root   3532 Aug 22 10:26 APIC.dat
> -rw-r--r-- 1 root root     48 Aug 22 10:26 BDAT.dat
> -rw-r--r-- 1 root root    824 Aug 22 10:26 DMAR.dat
> -rw-r--r-- 1 root root  83509 Aug 22 10:26 DSDT.dat
> -rw-r--r-- 1 root root    244 Aug 22 10:26 FACP.dat
> -rw-r--r-- 1 root root     64 Aug 22 10:26 FACS.dat
> -rw-r--r-- 1 root root     68 Aug 22 10:26 FPDT.dat
> -rw-r--r-- 1 root root     56 Aug 22 10:26 HPET.dat
> -rw-r--r-- 1 root root    304 Aug 22 10:26 MCEJ.dat
> -rw-r--r-- 1 root root     60 Aug 22 10:26 MCFG.dat
> -rw-r--r-- 1 root root   6712 Aug 22 10:26 MPST.dat
> -rw-r--r-- 1 root root    232 Aug 22 10:26 MSCT.dat
> -rw-r--r-- 1 root root    172 Aug 22 10:26 PCCT.dat
> -rw-r--r-- 1 root root     96 Aug 22 10:26 PMCT.dat
> -rw-r--r-- 1 root root     48 Aug 22 10:26 RASF.dat
> -rw-r--r-- 1 root root    108 Aug 22 10:26 SLIT.dat
> -rw-r--r-- 1 root root     80 Aug 22 10:26 SPCR.dat
> -rw-r--r-- 1 root root     65 Aug 22 10:26 SPMI.dat
> -rw-r--r-- 1 root root   6448 Aug 22 10:26 SRAT.dat
> -rw-r--r-- 1 root root    100 Aug 22 10:26 SSDT1.dat
> -rw-r--r-- 1 root root 283527 Aug 22 10:26 SSDT2.dat
> -rw-r--r-- 1 root root     66 Aug 22 10:26 UEFI.dat
> -rw-r--r-- 1 root root     64 Aug 22 10:26 WDDT.dat
> 
> assume for 32sockets will have four times bigger with DSDT and SSDT.
> (with more pci and cpus)
> 
> So we can not have O(1) the size.
> 
> Russ, What is ACPI table size on your big machine?

This is from a 256 socket 32TB system.

 Reserving 256MB of memory at 66973408MB for crashkernel (System RAM: 32501719MB)
 ACPI: RSDP 000000007ef3d014 00024 (v02 INTEL )
 ACPI: XSDT 000000007ef3d120 0007C (v01 INTEL  TIANO    00000000      01000013)
 ACPI: FACP 000000007ef3a000 000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
 ACPI: DSDT 000000007e6c3000 7F493E (v02   SGI2      UVX 00000002 MSFT 01000013)
 ACPI: FACS 000000007d147000 00040
 ACPI: UEFI 000000007ef3c000 0012A (v01  INTEL  RstScuO 00000000      00000000)
 ACPI: UEFI 000000007ef3b000 0005C (v01  INTEL  RstScuV 00000000      00000000)
 ACPI: HPET 000000007ef39000 00038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
 ACPI: SSDT 000000007ef33000 05352 (v02  INTEL ROSECITY 00000003 INTL 20070508)
 ACPI: SLIT 000000007ef10000 1002C (v01   SGI2      UVX 00000002 MSFT 00000001)
 ACPI: APIC 000000007eeee000 10070 (v03   SGI2      UVX 00000002 MSFT 00000001)
 ACPI: SRAT 000000007eeb8000 1A830 (v03   SGI2      UVX 00000002 MSFT 00000001)
 ACPI: MCFG 000000007d6d4000 0105C (v01   SGI2      UVX 00000002 MSFT 00000001)
 ACPI: SPCR 000000007e6c2000 00050 (v01                 00000000      00000000)
 ACPI: DMAR 000000007d6d3000 0013C (v01 INTEL  TIANO    00000001 MSFT 01000013)

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
