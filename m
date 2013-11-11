Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3KKIhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:37:18 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40331 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3KKIhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:37:15 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.130.80]
In-Reply-To: <CACVXFVMvvG1unnR0rsmBMdp9p19Q3JRbURxZF-UWxvrThDPKTw@mail.gmail.com>
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
	<CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com>
	<CACVXFVMvvG1unnR0rsmBMdp9p19Q3JRbURxZF-UWxvrThDPKTw@mail.gmail.com>
Date: Mon, 11 Nov 2013 16:37:15 +0800
Message-ID: <CAFRkauCW3FDSuh4t0gvmSWH1m0+qaG0XSoBxmk30Wq1FMy7iFw@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Axel Lin <axel.lin@ingics.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/11 Ming Lei <tom.leiming@gmail.com>:
> Hi,
>
> On Mon, Nov 11, 2013 at 2:43 PM, Axel Lin <axel.lin@ingics.com> wrote:
>> 2013/11/11 Rusty Russell <rusty@rustcorp.com.au>:
>>
>> Hi Rusty,
>>
>> I don't have other noMMU platform to test.
>> But I think this issue impacts various !CONFIG_MMU platforms:
>> We have CONFIG_PAGE_OFFSET=0xC0000000 in various default configs.
>> For !CONFIG_MMU case, it just don't use the CONFIG_PAGE_OFFSET setting.
>> So use CONFIG_PAGE_OFFSET to filter symbols looks wrong to me for all
>> !CONFIG_MMU cases.
>>
>> Below is PAGE_OFFSET setting for !CONFIG_MMU case:
>> (arch/arm/include/asm/memory.h)
>>
>> #ifndef PHYS_OFFSET
>> #define PHYS_OFFSET             UL(CONFIG_DRAM_BASE)
>> #endif
>>
>> #ifndef END_MEM
>> #define END_MEM                 (UL(CONFIG_DRAM_BASE) + CONFIG_DRAM_SIZE)
>> #endif
>>
>> #ifndef PAGE_OFFSET
>> #define PAGE_OFFSET             (PHYS_OFFSET)
>> #endif
>>
>> My patchs for gpl327xx SoC is still in very early stage.
>> I think you should send your fix upstream because I think it impacts other
>> noMMU platforms (for above reason).
>
> I suggest to do it when we are clear behind the break.
>
> As I mentioned, no matter what PAGE_OFFSET is, if you link vmlinux
> from the address of PAGE_OFFSET(that is what arm's link script in tree
> does), the filter won't break anything.

Hi Ming,

commit f6537f2f "scripts/kallsyms: filter symbols not in kernel address space",
uses CONFIG_PAGE_OFFSET as kernel_start_addr.
However, for !CONFIG_MMU case we have :
    PAGE_OFFSET != CONFIG_PAGE_OFFSET.

That is why I think the filter breaks !MMU platforms.

Regards,
Axel
