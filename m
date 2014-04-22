Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaDVPjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:39:49 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62524 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaDVPja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:39:30 -0400
MIME-Version: 1.0
In-Reply-To: <000501cf5d48$4cf707c0$e6e51740$%han@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
	<000901cf592e$563bc8c0$02b35a40$%han@samsung.com>
	<20140416165724.GG7802@e106497-lin.cambridge.arm.com>
	<16730530.rJ9T0MsYmt@wuerfel>
	<000001cf5d04$982a6000$c87f2000$%han@samsung.com>
	<000501cf5d48$4cf707c0$e6e51740$%han@samsung.com>
Date: Tue, 22 Apr 2014 10:39:29 -0500
Message-ID: <CAL_JsqJ5=7bvxQZhbn4unDH0wTB=qn4nEnqGCnskvOmRhJ8JQw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] PCI: designware: Add ARM64 PCI support
From: Rob Herring <robherring2@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Pratyush Anand <pratyush.anand@st.com>, Marek Vasut <marex@denx.de>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Byungho An <bh74.an@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 4:58 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Monday, April 21, 2014 10:54 AM, Jingoo Han wrote:
>> On Thursday, April 17, 2014 3:26 AM, Arnd Bergmann wrote:
>> > On Wednesday 16 April 2014 17:57:24 Liviu Dudau wrote:
>> > > Jingoo,
>> > >
>> > > Thanks for taking a stab at trying to convert a host bridge
>> > > driver to use the new generic host bridge code.
>> > >
>> > > I do however have concerns on the direction you took. You have split
>> > > your driver in two, depending on whether it was CONFIG_ARM or CONFIG_ARM64,
>> > > even if (with my series) it should be no reason why the host bridge
>> > > driver should not work on other architectures as well once they are
>> > > converted.
>> >
>> > Right.
>> >
>> > > Also, some of the functions that you use have identical names but different
>> > > signatures depending on what arch you have selected. This is really bad
>> > > in my books!
>
> [.....]
>
>> > > What about creating functions that use my series directly if CONFIG_ARM64 is
>> > > defined (or any CONFIG_ you want to create for your driver that you select
>> > > from CONFIG_ARM64) and otherwise implement the CONFIG_ARM version? That
>> > > way your driver will call only one API without any #ifdef and when arm code
>> > > gets converted you drop your adaptation functions. Or (better yet), have a
>> > > stab at converting bios32 (Rob Herring has already provided some hints on
>> > > how to do it for arch/arm).
>>
>> To: Liviu Dudau
>>
>> Sorry, but I will not implement this.

Then you will not get what you want upstream.

>> At first, you had to think the compatibility with ARM32 PCIe.
>> Why do you want other engineers to take this load?

That is how the process works.

> (+cc Rob Herring)
>
> Um, I am looking at Rob Herring's patchset for Versatile PCI. [1]
> Then, do you mean the following?
>
> 1. Add Rob Herring's patch converting bios32. [2]

I would expect all or most of this patch to go away in Liviu's next
version. It does at least show we don't have to fix all of ARM PCI
support to use of_create_pci_host_bridge on ARM.

Rob
