Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3HWUs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:48:56 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:58346 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3HWUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130823203050.GB31817@sgi.com>
References: <20130822202158.GD3490@mtj.dyndns.org>
	<1377205598.10300.715.camel@misato.fc.hp.com>
	<20130822212111.GF3490@mtj.dyndns.org>
	<1377209861.10300.756.camel@misato.fc.hp.com>
	<20130823130440.GC10322@mtj.dyndns.org>
	<1377274448.10300.777.camel@misato.fc.hp.com>
	<521793BB.9080605@gmail.com>
	<CAE9FiQXZ610BrVaXoxY70NS3CaSku7mcVFx+x34-jpYUkG2rdQ@mail.gmail.com>
	<201308231825.r7NIPQl5015165@mail.zytor.com>
	<CAE9FiQVxQtpHp+0b1zFaA4YHx6hDiNSHKDveU=FzS5LwR80RmA@mail.gmail.com>
	<20130823203050.GB31817@sgi.com>
Date: Fri, 23 Aug 2013 13:48:54 -0700
X-Google-Sender-Auth: 9j6UomOpTof7gQ5XLGC0nFTAX7I
Message-ID: <CAE9FiQU_JyJbYjpBQjfusc0=qjQjkA+2cxbVynEi_0mgKJFF4g@mail.gmail.com>
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
From: Yinghai Lu <yinghai@kernel.org>
To: Russ Anderson <rja@sgi.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 1:30 PM, Russ Anderson <rja@sgi.com> wrote:
> On Fri, Aug 23, 2013 at 01:08:56PM -0700, Yinghai Lu wrote:
>> On Fri, Aug 23, 2013 at 11:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:

>> Russ, What is ACPI table size on your big machine?
>
> This is from a 256 socket 32TB system.
>
>  Reserving 256MB of memory at 66973408MB for crashkernel (System RAM: 32501719MB)
>  ACPI: RSDP 000000007ef3d014 00024 (v02 INTEL )
>  ACPI: XSDT 000000007ef3d120 0007C (v01 INTEL  TIANO    00000000      01000013)
>  ACPI: FACP 000000007ef3a000 000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
>  ACPI: DSDT 000000007e6c3000 7F493E (v02   SGI2      UVX 00000002 MSFT 01000013)
>  ACPI: FACS 000000007d147000 00040
>  ACPI: UEFI 000000007ef3c000 0012A (v01  INTEL  RstScuO 00000000      00000000)
>  ACPI: UEFI 000000007ef3b000 0005C (v01  INTEL  RstScuV 00000000      00000000)
>  ACPI: HPET 000000007ef39000 00038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
>  ACPI: SSDT 000000007ef33000 05352 (v02  INTEL ROSECITY 00000003 INTL 20070508)
>  ACPI: SLIT 000000007ef10000 1002C (v01   SGI2      UVX 00000002 MSFT 00000001)
>  ACPI: APIC 000000007eeee000 10070 (v03   SGI2      UVX 00000002 MSFT 00000001)
>  ACPI: SRAT 000000007eeb8000 1A830 (v03   SGI2      UVX 00000002 MSFT 00000001)
>  ACPI: MCFG 000000007d6d4000 0105C (v01   SGI2      UVX 00000002 MSFT 00000001)
>  ACPI: SPCR 000000007e6c2000 00050 (v01                 00000000      00000000)
>  ACPI: DMAR 000000007d6d3000 0013C (v01 INTEL  TIANO    00000001 MSFT 01000013)
>

so the DSDT is 7F493E, and total is more than 8M.

that will need BRK to be extended 16M?

Thanks

Yinghai
