Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3KKKmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:42:00 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:63324 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3KKKl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:41:57 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVMzOzD+D-MQCUBvC80d4zS-TJfcucKuUvzerGs6gT1fEg@mail.gmail.com>
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
	<CAFRkauCW3FDSuh4t0gvmSWH1m0+qaG0XSoBxmk30Wq1FMy7iFw@mail.gmail.com>
	<CACVXFVMzOzD+D-MQCUBvC80d4zS-TJfcucKuUvzerGs6gT1fEg@mail.gmail.com>
Date: Mon, 11 Nov 2013 18:41:56 +0800
Message-ID: <CACVXFVOnVXcVdRCm=OfPjpvvWCiXi8GRV+9ViOGmSZ3tTf6WDg@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Ming Lei <tom.leiming@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 11, 2013 at 5:57 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi,
>
> On Mon, Nov 11, 2013 at 4:37 PM, Axel Lin <axel.lin@ingics.com> wrote:
>> 2013/11/11 Ming Lei <tom.leiming@gmail.com>:
>>
>> Hi Ming,
>>
>> commit f6537f2f "scripts/kallsyms: filter symbols not in kernel address space",
>> uses CONFIG_PAGE_OFFSET as kernel_start_addr.
>> However, for !CONFIG_MMU case we have :
>>     PAGE_OFFSET != CONFIG_PAGE_OFFSET.
>
> Yes, it is the cause, and strictly speaking, commit f6537f2f is wrong,
> but triggered with bogus CONFIG_PAGE_OFFSET if !CONFIG_MMU.
>
> We can fix it either by Rusty's patch or removing the bogus
> CONFIG_PAGE_OFFSET for !CONFIG_MMU.

Rusty, maybe we need revert commit f6537f2f "scripts/kallsyms: filter
symbols not in kernel address space", since CONFIG_PAGE_OFFSET
may be bogus on !MMU or not defined on ARCHs(most of 64bit arch,
no regression report because scripts/kallsyms may get zero
kernel_start_addr)

As I thought of, another way for fixing original problem is to define a RO
global variable in kernel and set its value as PAGE_OFFSET, then let
scripts/kallsyms use it as kernel start address, or do you other
suggestions?


Thanks,
-- 
Ming Lei
