Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbaFLOOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:14:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43261 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaFLON7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:13:59 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-2d-5399b5a4821f
Message-id: <5399B594.2040205@samsung.com>
Date: Thu, 12 Jun 2014 16:13:40 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Daniel Drake <drake@endlessm.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robin Holt <holt@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] Handle non-secure L2C initialization on Exynos4
References: <CAD8Lp46MbKZrCAMp+9T9LbWTB4uHRDdivhtjoQbkTyBbK48EgQ@mail.gmail.com>
In-reply-to: <CAD8Lp46MbKZrCAMp+9T9LbWTB4uHRDdivhtjoQbkTyBbK48EgQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t/xy7pLts4MNjj0Q9bi0fzHzBb90zpY
	LXoXXGWz2N45g91iyp/lTBabHl9jtbi8aw6bxewl/SwWty/zWrzuW8NssWrXH0aL/Ve8HHg8
	Wpp72Dy+fZ3E4nG5r5fJY9H3LI+ds+6ye9y5tofNY/OSeo++LasYPe5ef8nkcfzGdiaPz5vk
	ArijuGxSUnMyy1KL9O0SuDJmL7vFWvCdt6LzxyfWBsbZ3F2MnBwSAiYSh3/PY4WwxSQu3FvP
	1sXIxSEksJRRYs65mWwgCSGBz4wS/4/pgNi8AloSD69vZQexWQRUJeb/+gdWwyagJvG54RGY
	zQ9Us6bpOksXIweHqECExOMLQhCtghI/Jt9jAbFFgFp/LW9mBdnFLDCdWWLazVvMIAlhAQ+J
	r9+PsELsDZB4/vcm2ExOgWCJLxOmg9nMAjoS+1unQdnyEpvXvGWewCg4C8mOWUjKZiEpW8DI
	vIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJMa+7GBcfMzqEKMAB6MSD6/G6xnBQqyJZcWV
	uYcYJTiYlUR4tTfPDBbiTUmsrEotyo8vKs1JLT7EyMTBKdXAuKb8/yEr26nfT95nFymIXble
	dz0Lu6fv2/D02btWCzIb39T+/TaHK2Xq+0mVBeLv+rjq1r7/8yjpBN8CO85HX5c+mC1fs/xG
	veLpu0G/D3rLeYnYPV98Q6rUdX19zdsTUVf3/Ah7qemtlb9/iczn/F86jNsMPm0x95myfrOZ
	m9W9pRbJRqHmn5VYijMSDbWYi4oTAbjKkiyPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 12.06.2014 15:38, Daniel Drake wrote:
> Hi Tomasz,
> 
> Thanks for working on this!
> 
> I have just tried this, against Linus master
> 64b2d1fbbfda07765dae3f601862796a61b2c451.
> Added patch "ARM: dts: Initial ODROID U2 support" and booted on
> ODROID-U2. I believe this board has the security enabled.
> 
> Unfortunately, it hangs during early boot. With earlyprintk the last
> messages seen are:
> 
> L2C: platform modifies aux control register: 0x02070000 -> 0x3e470001
> L2C: platform provided aux values permit register corruption.
> L2C: DT/platform modifies aux control register: 0x02070000 -> 0x3e470001
> L2C-310 enabling early BRESP for Cortex-A9
> L2C-310: enabling full line of zeros but not enabled in Cortex-A9
> L2C-310 ID prefetch enabled, offset 1 lines
> L2C-310 dynamic clock gating enabled, standby mode enabled
> L2C-310 cache controller enabled, 16 ways, 1024 kB
> L2C-310: CACHE_ID 0x4100c4c8, AUX_CTRL 0x7e470001
> 

Thanks for testing. We have some ODROIDs U2 and U3 here too so I'll try
to reproduce and investigate the issue.

> I then tried to go back to the earlier patch "ARM: EXYNOS: Add secure
> firmware support for l2x0 init" (attached, needed a rebase) but that
> one also now hangs at:
> 
> L2C: platform modifies aux control register: 0x02070000 -> 0x3e470001
> 
> It did work on 3.14 though. Looking at the changelogs, many changes
> have been made to l2x0 recently. Can you confirm that you have tested
> your patches against a kernel with all of Russell King's recent
> changes?

I'm usually working on latest linux-next, so I'm pretty sure all the
mentioned patches were already in my tree. The base for this series was
next-20140610 tag of linux-next tree.

Best regards,
Tomasz
