Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaAVQKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:10:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17385 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaAVQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:10:10 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-bb-52dfed606684
Message-id: <1390407007.18340.13.camel@AMDC1943>
Subject: Re: [PATCH RESEND] cpufreq: exynos: Fix build error of no type of
 module_init
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 22 Jan 2014 17:10:07 +0100
In-reply-to: <52DFE7D9.5050001@windriver.com>
References: <1390400476-22951-1-git-send-email-k.kozlowski@samsung.com>
 <CAKohpo=2wR+Sqwxj4koH0rvuk29BkNyAZgN0RR7bVH+3uqpB1Q@mail.gmail.com>
 <1390402760.18340.6.camel@AMDC1943> <1390405030.18340.11.camel@AMDC1943>
 <52DFE7D9.5050001@windriver.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xy7oJb+8HGRz5LmbxtOkHu0Xvgqts
	Fmeb3rBbvHm4mdFi0+NrrBaXd81hs/jce4TRYsb5fUwW1/YeZ7Y4c/oSq8X6Ga9ZLDZ+9XDg
	8bhzbQ+bx+Yl9R5brrazePRtWcXo8XmTnMf6LVuZAtiiuGxSUnMyy1KL9O0SuDL2XrnHXvCS
	o+LyvyvsDYzf2boYOTkkBEwkTs37xghhi0lcuLceKM7FISSwlFFizsvljBDOZ0aJZX//soBU
	8QoYSGzc0Q7WLSwQIdFxaQ1YnE3AWGLz8iVgcREBQ4llbzawgjQzC6xikXi26BATSIJFQFVi
	09LnYDangK5E6/LTUBv+MEr03FvPDJJgFlCXmDRvETPETUoSu9s72SHi8hKb17xlhrhCUOLH
	5HssExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQmLkyw7Gxces
	DjEKcDAq8fAG7roXJMSaWFZcmXuIUYKDWUmEl+X5/SAh3pTEyqrUovz4otKc1OJDjEwcnFIN
	jI3nzvu2elW8tLPZlfD74oLtbN9OT7aZ7lduIPKu/1p/D8OphBmxXm+UpnUVer3Xmc79fHvQ
	64MvckXLo732d14uOJ9+w4l3cYjF2RJtBpdNZuvnGps9Yd9Y8Tus/NeVRE3h+HMnDiwu/rtX
	gOP6/heawl7vV/2PCGaME2n2/fFwxxTpje//sCixFGckGmoxFxUnAgCDFpQ/bwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 10:46 -0500, Paul Gortmaker wrote:
> On 14-01-22 10:37 AM, Krzysztof Kozlowski wrote:
> > 
> >>
> >> Hi,
> >>
> >> A little more explanation from my side: the build error actually happens
> >> only on next/master, not Linus' tree.
> >>
> >> Mentioned commit which changes the driver to platform driver is in
> >> mainline since 3.12-rc2 so it seems this is not the cause of the build
> >> error. I think I need to find first the real cause of this build error.
> >>
> >> Best regards,
> >> Krzysztof
> > 
> > After bisecting, the real commit for build error is:
> > caa7dcde7c424cdc81698a6e4e48072eb67ec67e
> >     module: relocate module_init from init.h to module.h
> 
> Yep, even though I fixed a crap-tonne of implicit includes, and
> built all the arm configs, some were bound to sneak through.
> 
> I'll push a fix shortly to the init cleanup queue:
> 
>    http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/
> 
> so it will be fine for the next linux-next tree.

Thanks, the same issue applies to drivers/cpufreq/exynos-cpufreq.c.

Best regards,
Krzysztof

