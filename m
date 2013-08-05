Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3HEPap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:30:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57715 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3HEPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:30:43 -0400
Message-ID: <51FFC4EA.40908@ti.com>
Date: Mon, 5 Aug 2013 11:29:46 -0400
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
References: <20130629175743.GA382@mtj.dyndns.org> <CAE9FiQXHuP-n0eZ9wN73V4nSvE+XEExDsx1t50_=YaW+V=LGLg@mail.gmail.com> <20130629195549.GE3353@n2100.arm.linux.org.uk> <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com> <51D18DBA.6090608@ti.com> <51F1A7AA.8080700@ti.com> <20130725223658.GJ26107@mtj.dyndns.org> <51F1B17F.30902@ti.com> <20130726030812.GB30195@mtj.dyndns.org> <51FC1F3A.8090201@ti.com> <20130805150127.GC19631@mtj.dyndns.org>
In-Reply-To: <20130805150127.GC19631@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 August 2013 11:01 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Aug 02, 2013 at 05:06:02PM -0400, Santosh Shilimkar wrote:
>> Looking at the situation, how about proceeding with patch updating
>> the bootmem API signatures to use phys_addr_t  which can unblock me
>> to get my machine working.
> 
> I'm not sure about that.  No matter how you play it, it'll end up
> duplicating memblock interface.
> 
fair enough.

>> Introduction of new API, conversions of core kernel code and then
> 
> What new API are we talking about?  Wasn't the plan to convert core
> kernel code to use memblock and let bootmem emulate bootmem API?
> There's no new API.
> 
So looks like I am bit confused here. The current memblock_alloc()
API just returns the physical address which not mapped memory.
Most of the bootmem users including core code expects the
mapped memory pointer which the code can directly operate on.
So the current memblock_alloc() isn't going to help. The nobootmem.c
has __alloc_memory_core_early() which is actually used by most of
the bootmem wrappers to achieve the same. So my assumption was
that we need an equivalent exported memblock API.

What am I missing?

>> arches moving away from bootmem is going to take significant time
> 
> And arches moving away from bootmem doesn't have to happen now.
> 
I agree. The core code conversion is more of an issue.

Regards,
Santosh
