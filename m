Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3HWXEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:04:06 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:52183 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3HWXEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAD11hGzE5FoVaA+r16eJdt_Bor_kPGvSALEXov4bcBJZGqVnGg@mail.gmail.com>
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
	<CAE9FiQU_JyJbYjpBQjfusc0=qjQjkA+2cxbVynEi_0mgKJFF4g@mail.gmail.com>
	<CAD11hGxm3K0sw885nH2QWb9N+5=q0qt+8trTAkUjzoejMepeTQ@mail.gmail.com>
	<CAE9FiQUzM1fHbJOkrCMC4dHD7QPpR=tXyJ-mW=y9G0XucJqyRQ@mail.gmail.com>
	<CAD11hGzE5FoVaA+r16eJdt_Bor_kPGvSALEXov4bcBJZGqVnGg@mail.gmail.com>
Date: Fri, 23 Aug 2013 16:04:03 -0700
X-Google-Sender-Auth: FVqtf8ICjW0W_lkXQvLgPCnpiBo
Message-ID: <CAE9FiQWO6KX7KViFLzhSFHfJsPj826=5Cd7z75JH=4257NRosw@mail.gmail.com>
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
From: Yinghai Lu <yinghai@kernel.org>
To: chen tang <imtangchen@gmail.com>
Cc: Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
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

> So we need to allocate memory. That is why you suggested to use BRK, right ?
> And the size seems to be a problem.
>
> So I suggest to use early_ioremap().
>
> 1. After paging is enabled, before direct mapping page tables are
> setup, we map the
>     initrd with early_ioremap(). And we are able to access it with va,
> even on 32bit.
>     Then we can find all tables.
> 2. We still use memblock to allocate memory. Maybe it will be
> hotpluggable memory,
>     but this memory can be freed when all the acpi tables are parsed, right ?
>
> So I want to try early_ioremap(). All these should be done in setup_arch().

no.
cpio search need to take whole range virtual address,
and early_ioremap has size limitation.
you will have to update cpio search to take mapping function.
could be too messy.

Yinghai
