Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3F2UIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:08:16 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65370 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3F2UIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130629195549.GE3353@n2100.arm.linux.org.uk>
References: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com>
	<20130629152959.GB31339@mtj.dyndns.org>
	<20130629172123.GA3353@n2100.arm.linux.org.uk>
	<20130629175743.GA382@mtj.dyndns.org>
	<CAE9FiQXHuP-n0eZ9wN73V4nSvE+XEExDsx1t50_=YaW+V=LGLg@mail.gmail.com>
	<20130629195549.GE3353@n2100.arm.linux.org.uk>
Date: Sat, 29 Jun 2013 13:08:13 -0700
X-Google-Sender-Auth: 85uezcf1EK-hN8eDvXLbLj53b1k
Message-ID: <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com>
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
From: Yinghai Lu <yinghai@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 12:55 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Jun 29, 2013 at 12:29:55PM -0700, Yinghai Lu wrote:
>> >> On these SoCs which Santosh is working on, the main physical memory
>> >> mapping is above 4GB, with just a small alias below 4GB to allow the
>> >> system to boot without the MMU being on, as they may have more than
>> >> 4GB of RAM.  As I understand it, the small alias below 4GB is not
>> >> suitable for use as a "lowmem" mapping.
>>
>> is that 32bit ARM or 64bit ARM?
>
> Only 32-bit has LPAE.  Such things don't make sense on 64-bit CPUs.

32bit ARM does not support NO_BOOTMEM yet.

arch/arc/Kconfig:       select NO_BOOTMEM
arch/arm64/Kconfig:     select NO_BOOTMEM
arch/sparc/Kconfig:     select NO_BOOTMEM
arch/x86/Kconfig:config NO_BOOTMEM


so may need to
1. make 32bit ARM to use NO_BOOTMEM at first.

2 .we can add alloc_memblock as MACRO or inline for bootmem arches,

3. NO_BOOTMEM arches will have alloc_memblock in nobootmem.c

4. replace alloc_bootmem calling with alloc_memblock calling in core code.

Thanks

Yinghai
