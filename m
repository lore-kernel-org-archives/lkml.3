Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3HXClJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 22:41:09 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57726 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754553Ab3HXClI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 22:41:08 -0400
Date: Fri, 23 Aug 2013 21:41:05 -0500
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
Message-ID: <20130824024105.GB29600@sgi.com>
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

This is from a 255 socket, 4080 cpu, 15TB system.

-------------------------------------------------------
-rw-r--r-- 1 root root   65392 Aug 23 21:23 apic.dat
-rw-r--r-- 1 root root     316 Aug 23 21:23 dmar.dat
-rw-r--r-- 1 root root 8309249 Aug 23 21:23 dsdt.dat
-rw-r--r-- 1 root root     244 Aug 23 21:23 facp.dat
-rw-r--r-- 1 root root      64 Aug 23 21:23 facs.dat
-rw-r--r-- 1 root root      56 Aug 23 21:23 hpet.dat
-rw-r--r-- 1 root root    4172 Aug 23 21:23 mcfg.dat
-rw-r--r-- 1 root root      36 Aug 23 21:23 rsdp.dat
-rw-r--r-- 1 root root      80 Aug 23 21:23 rsdt.dat
-rw-r--r-- 1 root root   65069 Aug 23 21:23 slit.dat
-rw-r--r-- 1 root root      80 Aug 23 21:23 spcr.dat
-rw-r--r-- 1 root root  108168 Aug 23 21:23 srat.dat
-rw-r--r-- 1 root root   21330 Aug 23 21:23 ssdt.dat
-rw-r--r-- 1 root root      92 Aug 23 21:23 uefi1.dat
-rw-r--r-- 1 root root     298 Aug 23 21:23 uefi.dat
-rw-r--r-- 1 root root     124 Aug 23 21:23 xsdt.dat
-------------------------------------------------------

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
