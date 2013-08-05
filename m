Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3HEPsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:48:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49520 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab3HEPss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:48:48 -0400
Message-ID: <51FFC928.8020603@ti.com>
Date: Mon, 5 Aug 2013 11:47:52 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
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
References: <20130629195549.GE3353@n2100.arm.linux.org.uk> <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com> <51D18DBA.6090608@ti.com> <51F1A7AA.8080700@ti.com> <20130725223658.GJ26107@mtj.dyndns.org> <51F1B17F.30902@ti.com> <20130726030812.GB30195@mtj.dyndns.org> <51FC1F3A.8090201@ti.com> <20130805150127.GC19631@mtj.dyndns.org> <51FFC4EA.40908@ti.com> <20130805153822.GD19631@mtj.dyndns.org>
In-Reply-To: <20130805153822.GD19631@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 August 2013 11:38 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 05, 2013 at 11:29:46AM -0400, Santosh Shilimkar wrote:
>> So looks like I am bit confused here. The current memblock_alloc()
>> API just returns the physical address which not mapped memory.
> 
> The memory returned by memblock is mapped if the memory area being
> allocated can be mappable.  To access, the address just needs to be
> converted to va.
> 
>> Most of the bootmem users including core code expects the
>> mapped memory pointer which the code can directly operate on.
>> So the current memblock_alloc() isn't going to help. The nobootmem.c
>> has __alloc_memory_core_early() which is actually used by most of
>> the bootmem wrappers to achieve the same. So my assumption was
>> that we need an equivalent exported memblock API.
>>
>> What am I missing?
> 
> Oh, you weren't.  I was.  I thought we already had full interface
> implemented.  Yeah, it looks like we need to build something new
> around memblock / __alloc_memory_core_early().
> 
Exactly. This is what actually I referred as the new API.

Regards,
Santosh

