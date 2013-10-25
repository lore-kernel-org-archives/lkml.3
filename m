Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3JYNfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:35:09 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52017 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab3JYNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:35:07 -0400
Date: Fri, 25 Oct 2013 06:34:54 -0700
From: Kees Cook <kees@outflux.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: RW and executable hole in page tables on x86_64
Message-ID: <20131025133454.GC4994@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed there's a chunk of kernel memory still marked RW and x. See
0xffffffff82956000 below...

---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff81a00000          10M     ro         PSE GLB x  pmd
0xffffffff81a00000-0xffffffff81e00000           4M     ro         PSE GLB NX pmd
0xffffffff81e00000-0xffffffff82200000           4M     RW             GLB NX pte
0xffffffff82200000-0xffffffff82800000           6M     RW         PSE GLB NX pmd
0xffffffff82800000-0xffffffff82956000        1368K     RW             GLB NX pte
0xffffffff82956000-0xffffffff82a00000         680K     RW             GLB x  pte
0xffffffff82a00000-0xffffffffa0000000         470M                           pmd

HPA looked at it for a bit, but it wasn't obvious what was going on. It's
after the end of bss. I do note that the two adjacent regions add up to
2MiB. Is this some kind of leftover mapping? What is this region? Is there
a sensible place to clean it up?

Thanks,

-Kees

-- 
Kees Cook                                            @outflux.net
