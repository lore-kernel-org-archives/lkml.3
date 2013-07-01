Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3GAOK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:10:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53208 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab3GAOKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:10:54 -0400
Message-ID: <51D18DBA.6090608@ti.com>
Date: Mon, 1 Jul 2013 10:10:02 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
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
        Sam Ravnborg <sam@ravnborg.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
References: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com> <20130629152959.GB31339@mtj.dyndns.org> <20130629172123.GA3353@n2100.arm.linux.org.uk> <20130629175743.GA382@mtj.dyndns.org> <CAE9FiQXHuP-n0eZ9wN73V4nSvE+XEExDsx1t50_=YaW+V=LGLg@mail.gmail.com> <20130629195549.GE3353@n2100.arm.linux.org.uk> <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com>
In-Reply-To: <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 June 2013 04:08 PM, Yinghai Lu wrote:
> On Sat, Jun 29, 2013 at 12:55 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Sat, Jun 29, 2013 at 12:29:55PM -0700, Yinghai Lu wrote:
>>>>> On these SoCs which Santosh is working on, the main physical memory
>>>>> mapping is above 4GB, with just a small alias below 4GB to allow the
>>>>> system to boot without the MMU being on, as they may have more than
>>>>> 4GB of RAM.  As I understand it, the small alias below 4GB is not
>>>>> suitable for use as a "lowmem" mapping.
>>>
>>> is that 32bit ARM or 64bit ARM?
>>
>> Only 32-bit has LPAE.  Such things don't make sense on 64-bit CPUs.
> 
Thanks Russell for clarifying the issue on the thread. Another major
reason of not being to use 32 bit alias address space for lowmem
is that address space isn't coherent on the SOC am dealing with.

> 32bit ARM does not support NO_BOOTMEM yet.
> 
> arch/arc/Kconfig:       select NO_BOOTMEM
> arch/arm64/Kconfig:     select NO_BOOTMEM
> arch/sparc/Kconfig:     select NO_BOOTMEM
> arch/x86/Kconfig:config NO_BOOTMEM
> 
> 
> so may need to
> 1. make 32bit ARM to use NO_BOOTMEM at first.
> 
Sorry. I should have mentioned that in the change-log. 
I have been carrying some WIP patches for ARM. Will post them
on ARM list after finishing remainder of the testing.

> 2 .we can add alloc_memblock as MACRO or inline for bootmem arches,
> 
> 3. NO_BOOTMEM arches will have alloc_memblock in nobootmem.c
> 
> 4. replace alloc_bootmem calling with alloc_memblock calling in core code.
> 
Great that we all agree to see back of nobootmem.c and have a direct
memblock API. Will be happy to help in conversion to proposed new interfaces
if I can get the alloc_memblock API and core related changes.

Will be good to know who is going to create proposed memblock API
so that we all can collaborate in conversion.

Regards,
Santosh 
