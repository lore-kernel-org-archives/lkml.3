Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3KHD4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 22:56:05 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64896 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3KHD4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 22:56:03 -0500
MIME-Version: 1.0
X-Originating-IP: [111.240.70.217]
In-Reply-To: <87zjpf4w0j.fsf@rustcorp.com.au>
References: <1383789208.5970.1.camel@phoenix>
	<CACVXFVMn6RSXchQ8u47F35_J+YSnp1bwF1tr-8uCEYwvFsOfgQ@mail.gmail.com>
	<CAFRkauAEt-YhBt11opj_GVCLrxGsTSd2LowWGmukTSmGuJkd3A@mail.gmail.com>
	<CACVXFVO=QA-R1+twCL9fc_3vASg6Ap-3ezi=tU1MV1pdPYrfWw@mail.gmail.com>
	<CAFRkauAdR3=ByE0_B3OsqOBjmbz2a02EXb+6g-vn=1TJ7AZc8Q@mail.gmail.com>
	<CACVXFVMaLOfDvzdn_1NryQY59cgtLdMMqHL-_ZAa95MPz4p56Q@mail.gmail.com>
	<CAFRkauDe7V3N0AbfvE_=GEXHZ_Fw62VsA8p50wSUYE1-TRqMfw@mail.gmail.com>
	<87zjpf4w0j.fsf@rustcorp.com.au>
Date: Fri, 8 Nov 2013 11:56:02 +0800
Message-ID: <CAFRkauAH7VeuxCU7xQm8+26-P49FjmNyhOu8c4+G2Ki40xTA8g@mail.gmail.com>
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

2013/11/8 Rusty Russell <rusty@rustcorp.com.au>:
> Axel Lin <axel.lin@ingics.com> writes:
>> 2013/11/7 Ming Lei <tom.leiming@gmail.com>:
>>> Hi,
>>>
>>> On Thu, Nov 7, 2013 at 10:47 AM, Axel Lin <axel.lin@ingics.com> wrote:
>>>>
>>>> hi Ming,
>>>> Seems CONFIG_PAGE_OFFSET is not configurabe in "make menuconfig".
>>>> And I found CONFIG_PAGE_OFFSET=0xC0000000 for all below configs...
>>>> $ make at91_dt_defconfig; grep  CONFIG_PAGE_OFFSET .config
>>>> $ make ep93xx_defconfig; grep  CONFIG_PAGE_OFFSET .config
>>>> $ make imx_v4_v5_defconfig; grep CONFIG_PAGE_OFFSET .config
>>>> $ make mxs_defconfig; grep CONFIG_PAGE_OFFSET .config
>>>> $ make omap2plus_defconfig; grep CONFIG_PAGE_OFFSET .config
>>>> $ make s3c6400_defconfig; grep CONFIG_PAGE_OFFSET .config
>>>> $ make at91x40_defconfig; grep CONFIG_PAGE_OFFSET .config
>>>> ( at91x40_defconfig is also arm7tdmi )
>>>
>>> Firstly it can be configured via VMSPLIT_3GVMSPLIT_2G/VMSPLIT_1G.
>>>
>>> Secondly, configurable or not isn't the point, and maybe some uclinux
>>> platforms do not use CONFIG_PAGE_OFFSET at all, but they should
>>> set it as a reasonable value or at least be below than the start link
>>> address of vmlinux.
>>
>> Hi Ming,
>>
>> I found in arch/arm/include/asm/memory.h:
>> CONFIG_PAGE_OFFSET is not used if !CONFIG_MMU.
>> So looks like setting CONFIG_PAGE_OFFSET to other value still won't work.
>
> This seems like the simplest solution, but it may mean you still have
> crap in /proc/kallsyms.
>
> Does it work for you?

Yes, it works.

Thanks,
Axel
