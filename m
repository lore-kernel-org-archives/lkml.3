Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaA1TnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:43:05 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:53139 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaA1TnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:43:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140128171823.GN15937@n2100.arm.linux.org.uk>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
	<1390590670-25901-4-git-send-email-yinghai@kernel.org>
	<CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com>
	<CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com>
	<CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com>
	<20140128171823.GN15937@n2100.arm.linux.org.uk>
Date: Tue, 28 Jan 2014 11:43:02 -0800
X-Google-Sender-Auth: 8KfyHWml0ODGqM9tjUGF8EQYKos
Message-ID: <CAE9FiQUa3uKZNc=5fiuvcR4bjEeQ3=RuhFVxUyKyMsJwe2YurA@mail.gmail.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
From: Yinghai Lu <yinghai@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 9:18 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jan 28, 2014 at 09:12:27AM -0800, Yinghai Lu wrote:
>> On Tue, Jan 28, 2014 at 7:30 AM, Kevin Hilman <khilman@linaro.org> wrote:
>> > Like Olof, I noticed multiple boot failures on various ARM boards.
>> > I've confirmed that reverting the arch/arm part of this patch makes
>> > them all happily booting again.
>>
>> please try attached patch.
>
> Maybe I'm missing something, but there is no ARCH_LOW_ADDRESS_LIMIT
> defined in the ARM header files, so I don't see how adding that
> additional include changes anything.

there is one for arm64 and s390.

arch/arm64/include/asm/processor.h:#define ARCH_LOW_ADDRESS_LIMIT       PHYS_MAS
arch/s390/include/asm/processor.h:#define ARCH_LOW_ADDRESS_LIMIT        0x7fffff
