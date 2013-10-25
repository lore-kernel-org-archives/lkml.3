Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3JYO7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:59:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54651 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab3JYO7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:59:50 -0400
Message-ID: <526A874B.2040108@zytor.com>
Date: Fri, 25 Oct 2013 15:59:23 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <kees@outflux.net>
CC: "Yan, Zheng" <zheng.z.yan@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: RW and executable hole in page tables on x86_64
References: <20131025133454.GC4994@outflux.net>
In-Reply-To: <20131025133454.GC4994@outflux.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 02:34 PM, Kees Cook wrote:
> Hi,
> 
> I've noticed there's a chunk of kernel memory still marked RW and x. See
> 0xffffffff82956000 below...
> 
> ---[ High Kernel Mapping ]---
> 0xffffffff80000000-0xffffffff81000000          16M                           pmd
> 0xffffffff81000000-0xffffffff81a00000          10M     ro         PSE GLB x  pmd
> 0xffffffff81a00000-0xffffffff81e00000           4M     ro         PSE GLB NX pmd
> 0xffffffff81e00000-0xffffffff82200000           4M     RW             GLB NX pte
> 0xffffffff82200000-0xffffffff82800000           6M     RW         PSE GLB NX pmd
> 0xffffffff82800000-0xffffffff82956000        1368K     RW             GLB NX pte
> 0xffffffff82956000-0xffffffff82a00000         680K     RW             GLB x  pte
> 0xffffffff82a00000-0xffffffffa0000000         470M                           pmd
> 
> HPA looked at it for a bit, but it wasn't obvious what was going on. It's
> after the end of bss. I do note that the two adjacent regions add up to
> 2MiB. Is this some kind of leftover mapping? What is this region? Is there
> a sensible place to clean it up?
> 

It looks to be what is left after the 2 MB page for bss is broken up.
It doesn't mean it isn't broken, though.

	-hpa


