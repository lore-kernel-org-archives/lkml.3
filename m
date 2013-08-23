Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3HWUJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:09:00 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:35299 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab3HWUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:08:57 -0400
MIME-Version: 1.0
In-Reply-To: <201308231825.r7NIPQl5015165@mail.zytor.com>
References: <20130821204041.GC2436@htj.dyndns.org>
	<1377124595.10300.594.camel@misato.fc.hp.com>
	<20130822033234.GA2413@htj.dyndns.org>
	<1377186729.10300.643.camel@misato.fc.hp.com>
	<20130822183130.GA3490@mtj.dyndns.org>
	<1377202292.10300.693.camel@misato.fc.hp.com>
	<20130822202158.GD3490@mtj.dyndns.org>
	<1377205598.10300.715.camel@misato.fc.hp.com>
	<20130822212111.GF3490@mtj.dyndns.org>
	<1377209861.10300.756.camel@misato.fc.hp.com>
	<20130823130440.GC10322@mtj.dyndns.org>
	<1377274448.10300.777.camel@misato.fc.hp.com>
	<521793BB.9080605@gmail.com>
	<CAE9FiQXZ610BrVaXoxY70NS3CaSku7mcVFx+x34-jpYUkG2rdQ@mail.gmail.com>
	<201308231825.r7NIPQl5015165@mail.zytor.com>
Date: Fri, 23 Aug 2013 13:08:56 -0700
X-Google-Sender-Auth: cOmmjWQ454kwCQz-hcqMMJjXgbQ
Message-ID: <CAE9FiQVxQtpHp+0b1zFaA4YHx6hDiNSHKDveU=FzS5LwR80RmA@mail.gmail.com>
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>, Toshi Kani <toshi.kani@hp.com>,
        Tejun Heo <tj@kernel.org>, Tang Chen <tangchen@cn.fujitsu.com>,
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

On Fri, Aug 23, 2013 at 11:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> BRK makes sense as long as you can set a sane O(1) size limit.
>
>>
>>put the acpi override table in BRK, we still need ok from HPA.
>>I have impression that he did not like it, so want to confirm from him.

on 8 sockets system:
-rw-r--r-- 1 root root   3532 Aug 22 10:26 APIC.dat
-rw-r--r-- 1 root root     48 Aug 22 10:26 BDAT.dat
-rw-r--r-- 1 root root    824 Aug 22 10:26 DMAR.dat
-rw-r--r-- 1 root root  83509 Aug 22 10:26 DSDT.dat
-rw-r--r-- 1 root root    244 Aug 22 10:26 FACP.dat
-rw-r--r-- 1 root root     64 Aug 22 10:26 FACS.dat
-rw-r--r-- 1 root root     68 Aug 22 10:26 FPDT.dat
-rw-r--r-- 1 root root     56 Aug 22 10:26 HPET.dat
-rw-r--r-- 1 root root    304 Aug 22 10:26 MCEJ.dat
-rw-r--r-- 1 root root     60 Aug 22 10:26 MCFG.dat
-rw-r--r-- 1 root root   6712 Aug 22 10:26 MPST.dat
-rw-r--r-- 1 root root    232 Aug 22 10:26 MSCT.dat
-rw-r--r-- 1 root root    172 Aug 22 10:26 PCCT.dat
-rw-r--r-- 1 root root     96 Aug 22 10:26 PMCT.dat
-rw-r--r-- 1 root root     48 Aug 22 10:26 RASF.dat
-rw-r--r-- 1 root root    108 Aug 22 10:26 SLIT.dat
-rw-r--r-- 1 root root     80 Aug 22 10:26 SPCR.dat
-rw-r--r-- 1 root root     65 Aug 22 10:26 SPMI.dat
-rw-r--r-- 1 root root   6448 Aug 22 10:26 SRAT.dat
-rw-r--r-- 1 root root    100 Aug 22 10:26 SSDT1.dat
-rw-r--r-- 1 root root 283527 Aug 22 10:26 SSDT2.dat
-rw-r--r-- 1 root root     66 Aug 22 10:26 UEFI.dat
-rw-r--r-- 1 root root     64 Aug 22 10:26 WDDT.dat

assume for 32sockets will have four times bigger with DSDT and SSDT.
(with more pci and cpus)

So we can not have O(1) the size.

Russ, What is ACPI table size on your big machine?

Thanks

Yinghai
