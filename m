Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3KKGnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 01:43:37 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56704 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3KKGn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 01:43:29 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.130.80]
In-Reply-To: <87y54vzszo.fsf@rustcorp.com.au>
References: <1383789208.5970.1.camel@phoenix>
	<CACVXFVMn6RSXchQ8u47F35_J+YSnp1bwF1tr-8uCEYwvFsOfgQ@mail.gmail.com>
	<CAFRkauAEt-YhBt11opj_GVCLrxGsTSd2LowWGmukTSmGuJkd3A@mail.gmail.com>
	<CACVXFVO=QA-R1+twCL9fc_3vASg6Ap-3ezi=tU1MV1pdPYrfWw@mail.gmail.com>
	<CAFRkauAdR3=ByE0_B3OsqOBjmbz2a02EXb+6g-vn=1TJ7AZc8Q@mail.gmail.com>
	<CACVXFVMaLOfDvzdn_1NryQY59cgtLdMMqHL-_ZAa95MPz4p56Q@mail.gmail.com>
	<CAFRkauDe7V3N0AbfvE_=GEXHZ_Fw62VsA8p50wSUYE1-TRqMfw@mail.gmail.com>
	<87zjpf4w0j.fsf@rustcorp.com.au>
	<CACVXFVNHryPXy2NQhPwXkoCeLUXQSgrWmgBkMNtGD_=X_62_5Q@mail.gmail.com>
	<CAFRkauDGiy3yZOwKFWMEJvYUe0OoXMEZHKaxogZHdgzMxexdHA@mail.gmail.com>
	<CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com>
	<87y54vzszo.fsf@rustcorp.com.au>
Date: Mon, 11 Nov 2013 14:43:28 +0800
Message-ID: <CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Axel Lin <axel.lin@ingics.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ming Lei <tom.leiming@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/11 Rusty Russell <rusty@rustcorp.com.au>:
> Ming Lei <tom.leiming@gmail.com> writes:
>> Hi Axel,
>>
>> On Fri, Nov 8, 2013 at 12:20 PM, Axel Lin <axel.lin@ingics.com> wrote:
>>>
>>>
>>> Hi Ming,
>>>
>>> I have patches on top of 3.12 to support gpl32700 SoC.
>>> So you cannot find this platform on mainline kernel.
>>
>> OK, I see.
>>
>>> I havn't tried perf, below is my config for your reference:
>>> (to make the config smaller, I grep out disabled config entries.)
>>
>> I doubt CONFIG_VMSPLIT_3G/CONFIG_PAGE_OFFSET isn't
>> used at all in your unmerged patchset, also your link script should
>> be different with in-tree arch/arm/kernel/vmlinux.lds.S, otherwise
>> you may put all your kernel symbols after 0xC00000000.
>>
>> Maybe you need to not define PAGE_OFFSET and let it be
>> PHYS_OFFSET at default, also VMSPLIT_3G shouldn't have
>> been there on non-MMU linux.
>
> OK, unless there are other platforms which have this issue, I'll
> leave it with you to hold this patch for merge with your SoC.


Hi Rusty,

I don't have other noMMU platform to test.
But I think this issue impacts various !CONFIG_MMU platforms:
We have CONFIG_PAGE_OFFSET=0xC0000000 in various default configs.
For !CONFIG_MMU case, it just don't use the CONFIG_PAGE_OFFSET setting.
So use CONFIG_PAGE_OFFSET to filter symbols looks wrong to me for all
!CONFIG_MMU cases.

Below is PAGE_OFFSET setting for !CONFIG_MMU case:
(arch/arm/include/asm/memory.h)

#ifndef PHYS_OFFSET
#define PHYS_OFFSET             UL(CONFIG_DRAM_BASE)
#endif

#ifndef END_MEM
#define END_MEM                 (UL(CONFIG_DRAM_BASE) + CONFIG_DRAM_SIZE)
#endif

#ifndef PAGE_OFFSET
#define PAGE_OFFSET             (PHYS_OFFSET)
#endif

My patchs for gpl327xx SoC is still in very early stage.
I think you should send your fix upstream because I think it impacts other
noMMU platforms (for above reason).

Thanks,
Axel
