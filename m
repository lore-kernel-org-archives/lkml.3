Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935109Ab3IDPEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:04:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9996 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3IDPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:04:37 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-14-52274c032e15
From: Tomasz Figa <t.figa@samsung.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: 3.12 merge window exynos cpufreq driver fails to build
Date: Wed, 04 Sep 2013 17:04:33 +0200
Message-id: <1480759.MNj1g1yX4l@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <CA+5PVA7T4P9vMH0r8p78aZYUrL8gzbpY9MmW9=nV3X0tE-e4NA@mail.gmail.com>
References: <CA+5PVA6SQ9JGBD3F=u5ysch-agp91oTK8ZbKsdQkz57yZ8OUHQ@mail.gmail.com>
 <7035644.8Kb1gDYsCf@amdc1227>
 <CA+5PVA7T4P9vMH0r8p78aZYUrL8gzbpY9MmW9=nV3X0tE-e4NA@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xq7rMPupBBhNucFo8bfrBbvHx9gpG
	i94FV9ksNj2+xmpxedccNosZ5/cxWfQv7GWy2PjVw4HDY+esu+wed67tYfPYvKTeo2/LKkaP
	R4tbGD0+b5ILYIvisklJzcksSy3St0vgyph45xZzwTH+ijev/jA1ME7l6WLk5JAQMJG4+LuP
	CcIWk7hwbz1bFyMXh5DAUkaJqb/7WSCcLiaJmz1X2UCq2ATUJD43PAKyOThEBJQkHjb7gtQw
	C8xhkpi3fQ7YJGEBZ4mvyw8xg9gsAqoSLfNvsIDYvAKaEvufrWQHsfkF1CXebXsKVi8q4Crx
	aeFGsDinQLDEnd13GSEW72SUuPxgFTtEs6DEj8n3wAYxC8hL7Ns/lRXC1pJYv/M40wRGwVlI
	ymYhKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJCI+LqDcekxq0OMAhyMSjy8
	GobqQUKsiWXFlbmHGCU4mJVEeOW8gUK8KYmVValF+fFFpTmpxYcYmTg4pRoYV7SfZcnUfjUj
	W2RVqv0B7SIn8yqJ9TWPVF4qeMy8wXdApiuyi/+twc8JRkfZ5/75MTtnz0PRwpuHfm+6y+7i
	vHCVmWKgddaVq4e+vd22paWai8Ulcs22zKSs3teS54zmckQsviVjtdT3f9XEkm2WXUuj8q84
	r9gb+qZosXblRpnKZ6bmHbvKlFiKMxINtZiLihMBOjVNl2YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 of September 2013 10:41:31 Josh Boyer wrote:
> On Wed, Sep 4, 2013 at 10:36 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> > Hi Josh,
> > 
> > On Wednesday 04 of September 2013 10:13:16 Josh Boyer wrote:
> >> Using Linus' tree as of this morning (v3.11-2654-g458c3f6), the
> >> exynos-cpufreq driver doesn't build because it includes a file that
> >> doesn't exist.
> >> 
> >> + make -s ARCH=arm V=1 -j4 bzImage KALLSYMS_EXTRA_PASS=1
> >> arch/arm/kernel/return_address.c:63:2: warning: #warning "TODO:
> >> return_address should use unwind tables" [-Wcpp]
> >> 
> >>  #warning "TODO: return_address should use unwind tables"
> >>  
> >>   ^
> >> 
> >> arch/arm/mm/dma-mapping.c:253:2: warning: #warning ARM Coherent DMA
> >> allocator does not (yet) support huge TLB [-Wcpp]
> >> 
> >>  #warning ARM Coherent DMA allocator does not (yet) support huge TLB
> >>  
> >>   ^
> >> 
> >> drivers/cpufreq/exynos-cpufreq.c:21:22: fatal error: plat/cpu.h: No
> >> such file or directory
> >> 
> >>  #include <plat/cpu.h>
> >>  
> >>                       ^
> >> 
> >> compilation terminated.
> >> make[2]: *** [drivers/cpufreq/exynos-cpufreq.o] Error 1
> >> 
> >> I'm guessing that <plat/cpu.h> file is supposed to come from
> >> arch/arm/plat-samsung/include/plat/, but I don't see anything that
> >> specifies a -I there.
> >> 
> >> Thoughts?
> > 
> > Could you attach config that could be used to trigger this? Thanks in
> > advance.
> 
> Attached.

Hmm, this does not look like config for kernel neither from Linus' nor 
linux-next tree. The first thing I can see is CONFIG_ARCH_EXYNOS_MULTI 
selected, which is not available in any mainline tree.

As for the build error itself, headers from plat/ are available for drivers 
only in single platform builds, they can't be included when multiplatform 
is enabled. The exynos-cpufreq driver is not multiplatform-aware yet and so 
you get the failure.

Best regards,
Tomasz

