Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbaD2Vka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:40:30 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:42403 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaD2Vk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:40:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140429191454.GB4726@pd.tnic>
References: <20140419025323.2408.88764.stgit@amt.stowe>
	<20140419135219.GC8109@pd.tnic>
	<20140420075936.GA19672@pd.tnic>
	<CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
	<20140426091031.GA10166@pd.tnic>
	<CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
	<20140428214036.GA32143@pd.tnic>
	<20140429073309.GE10997@alberich>
	<20140429102013.GA4726@pd.tnic>
	<535FC269.2000808@amd.com>
	<20140429191454.GB4726@pd.tnic>
Date: Tue, 29 Apr 2014 15:40:28 -0600
Message-ID: <CAL-B5D2Z7AvJZ3G2JLY6ZOZBRe4DGgO27RVJ_HHotGrnKL7Y1A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range capabilities
From: Myron Stowe <myron.stowe@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Robert Richter <rric@kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>, kim.naru@amd.com,
        Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 1:14 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Apr 29, 2014 at 10:16:57AM -0500, Suravee Suthikulanit wrote:
>> In the new code, the IO ECS was needed to retrieve the
>> AMD_NB_F1_MMIO_BASE_LIMIT_HI_REG (offset 0x180) during the early
>> initialization as part of (2) logic. However, this register exists only on
>> the newer systems.  However, as you mentioned, for (2) we can assume that
>> the MCFG exists for most of the systems (family10h and later), and should be
>> used instead.
>>
>> The main purpose of this patch set is mainly to deal with the the node
>> information (1).  So, we might need to split these all up and handle them
>> separately as needed where (2) and (3) will be used as fallback for older
>> systems where MCFG does not exist.
>
> So sounds to me like we want to get rid of the whole IO ECS deal
> altogether then.
>
> Now, I'm wondering whether we should kill it completely since I don't
> think anyone cares about numa node info being correct on K8, or? I'm
> specifically turning to our numascale friends who love to have a lot of
> nodes. :-)

I think we need to be careful here as there are two unrelated topics
being discussed together.  What started this whole thread was the need
for sysfs related numa_node information with respect to PCI devices
(1).  Without patch 1, platforms with newer AMD CPUs end up having
'-1' numa_node values for all PCI devices.

IO ECS has no bearing on patch 1, it only comes into play with patch 2
which is concerned with MMIO resource information when MCFG doesn't
exist.  For the particular issue I'm trying to get resolved, patch 2
is not needed.  However, since we have expended time and effort on
this subject, perhaps we should get this cleaned up while it has our
attention.

I'm all for deleting as much of amd_bus.c as possible due to its
"perennial maintenance headache".  The obvious choices seem to be all,
or some combination, of:
  o removing IO ECS logic,
  o removing IO/MMIO logic (assuming MCFG issues were long enough ago
to no longer be a concern),
  o start deprecating amd_bus.c by adding logic to skip if BIOS >= 2015

Myron

>
> Daniel, Steffen?
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
