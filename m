Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031640Ab3HIXeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:34:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49651 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031474Ab3HIXeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:34:14 -0400
MIME-Version: 1.0
In-Reply-To: <5204B93A.6030409@cn.fujitsu.com>
References: <1375954883-30225-1-git-send-email-tangchen@cn.fujitsu.com>
	<1375954883-30225-3-git-send-email-tangchen@cn.fujitsu.com>
	<CAE9FiQXUS9+heHagD45WAyO22NiGDMo3j2JumzvscypVhnjn9A@mail.gmail.com>
	<5204B93A.6030409@cn.fujitsu.com>
Date: Fri, 9 Aug 2013 16:34:13 -0700
X-Google-Sender-Auth: Wz_8luU764qbVSPq6yQzTeb53Y8
Message-ID: <CAE9FiQWSjkrFHBr3UrTYSpaCa8ThVrtPPVcaCyJrD0sGHcei3w@mail.gmail.com>
Subject: Re: [PATCH part4 2/4] x86, acpica, acpi: Try to find if SRAT is
 overrided earlier.
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 2:41 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> On 08/09/2013 12:29 AM, Yinghai Lu wrote:
> ......
>
>>
>> Please check if you can reuse first half of my patchset, so find and copy
>> override table earlier. the copied acpi tables could be near kernel code
>> range.
>>
>
> I don't think we need to do the finding step at that early time, in
> head64.c stage.
>
> Before pagetables are setup, we can use early_ioremap() to map the
> memory we want to access. We don't need to use phys addr. We can do
> it in setup_arch(), which has nothing to do with 32bit or 64bit.

if override the acpi tables early, you don't need to check firmware srat and
then override srat.
just check last one will be used by kernel.

So you don't need to dig initrd to find srat anymore.

>
>
>> Move finding in head64.c stage could help xen/dom0 a bit.
>> as Konrad is working on patchset with acpi override in xen hypervisor.
>> We can avoid override acpi table two times. Esp xen like to change
>> DMAR to XMAR.
>
>
> Would you please give some more info about this, and explain why finding
> override tables in head64.c stage is helpful for xen ?

xen usually can change acpi tables and pass to dom0 kernel. like change DMAR
to hide it to dom0 kernel.

also distribution could have same kernel to support bare metal and dom0.

so if we find the override kernel early in head64.c, dom0 path will not copy
actually as no one try to find that for them.

Yinghai
