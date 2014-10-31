Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbaJaH0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:26:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52509 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbaJaHZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:25:58 -0400
From: Eternal <eternal.n08@gmail.com>
X-Google-Original-From: Eternal Night@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mika.j.penttila@gmail.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        eternal.n08@gmail.com
Subject: Re: [PATCH] x86, kaslr: Prevent .bss from overlaping initrd
References: <CAChTCPzJst_O8OSdCAHQWGpn-Zc_j4hkk_Cs5MF2xubcGoC5Fg@mail.gmail.com>
	<CAChTCPyDEFEOHGhe2r1+RSouBsf3kW4r9XWW9JkxxubUsnasKw@mail.gmail.com>
Date: Fri, 31 Oct 2014 15:25:48 +0800
In-Reply-To: <CAChTCPyDEFEOHGhe2r1+RSouBsf3kW4r9XWW9JkxxubUsnasKw@mail.gmail.com>
	("Mika \=\?iso-8859-1\?Q\?Penttil\=E4\=22's\?\= message of "Thu, 30 Oct 2014
 21:09:33 +0200")
Message-ID: <86h9yk66pv.fsf@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Penttilä <mika.j.penttila@gmail.com> writes:

>> When choosing a random address, the current implementation does not take into
>> account the reversed space for .bss and .brk sections. Thus the relocated kernel
>> may overlap other components in memory, e.g. the initrd image:
>
> initrd should be included in the avoid arrays already, and bss is
> included in the output_size
>
> for choose_kernel_location(). So something else is going on?

output_size = sizeof(vmlinux.bin) + sizeof(vmlinux.relocs)

vmlinux.bin is an ELF file that contains a section header for .bss. Thus
output_size does not include sizeof(.bss).

Best Regards
Junjie Mao

>
> --Mika
>
> On Thu, Oct 30, 2014 at 9:06 PM, Mika Penttilä
> <mika.j.penttila@gmail.com> wrote:
>>> When choosing a random address, the current implementation does not take
>>> into
>>> account the reversed space for .bss and .brk sections. Thus the relocated
>>> kernel
>>> may overlap other components in memory, e.g. the initrd image:
>>
>> initrd should be included in the avoid arrays already, and bss is included
>> in the output_size
>>
>> for choose_kernel_location(). So something else is going on?
>>
>> --Mika
>>
>>
