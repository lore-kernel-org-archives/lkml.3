Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaAVO71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:59:27 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25820 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaAVO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:59:24 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f796d000005a13-50-52dfdccae424
Content-transfer-encoding: 8BIT
Message-id: <1390402760.18340.6.camel@AMDC1943>
Subject: Re: [PATCH RESEND] cpufreq: exynos: Fix build error of no type of
 module_init
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Date: Wed, 22 Jan 2014 15:59:20 +0100
In-reply-to: <CAKohpo=2wR+Sqwxj4koH0rvuk29BkNyAZgN0RR7bVH+3uqpB1Q@mail.gmail.com>
References: <1390400476-22951-1-git-send-email-k.kozlowski@samsung.com>
 <CAKohpo=2wR+Sqwxj4koH0rvuk29BkNyAZgN0RR7bVH+3uqpB1Q@mail.gmail.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xK7qn7twPMtj+lM/iadMPdoveBVfZ
	LM42vWG3ePNwM6PFpsfXWC0u75rDZvG59wijxYzz+5gszpy+xGqxfsZrFouNXz0cuD3uXNvD
	5rF5Sb3HlqvtLB59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CVcXyNbsFtkYr5nxcwNTDuEuxi
	5OSQEDCRaGq4wAxhi0lcuLeerYuRi0NIYCmjxMfX8xhBErwCghI/Jt9j6WLk4GAWkJc4cikb
	JMwsoC4xad4isF4hgc+MEid3KEKU60vsW3GBBcQWFoiQ6Li0BsxmEzCW2Lx8CRvIGBEBLYmX
	N1NBVjELNLFIvHk3G6yGRUBV4vzShawgNZwCwRJ984IgzuljlOh4Mp8R4k4lid3tnewTGAVm
	IbluFsJ1s5Bct4CReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSAx82cG4+JjVIUYBDkYl
	Ht7AXfeChFgTy4orcw8xSnAwK4nwpl6+HyTEm5JYWZValB9fVJqTWnyIkYmDU6qB0avBQ0zj
	7CXXvy2u292Pr1N7Gzj72ZnPbSV8TffZXXr26oiEbQg4czdx35nlb5u7yuwU125sVHrVsrSn
	04mnpvLFQevO07H7hUIFl8WEyi19cvB2F9fb39o/ZIs6RdY2Tda7tn/S3Y+zvvVNVlyvfIV7
	2e9nAguuT2a458gyR2vHxtzTF+KyjiuxFGckGmoxFxUnAgCqQWdPXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 20:12 +0530, Viresh Kumar wrote:
> On 22 January 2014 19:51, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Add missing include to fix build error:
> > drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
> > drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_init’ [-Werror=implicit-int]
> > drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
> > drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
> > drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_exit’ [-Werror=implicit-int]
> > drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
> > drivers/cpufreq/exynos-cpufreq.c:292:1: warning: ‘exynos_cpufreq_platdrv_init’ defined but not used [-Wunused-function]
> > cc1: some warnings being treated as errors
> > make[2]: *** [drivers/cpufreq/exynos-cpufreq.o] Error 1
> > make[1]: *** [drivers/cpufreq] Error 2
> >
> > Build error happens on gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
> > and was introduced by commit d568b6f71df1 (cpufreq: exynos: Convert
> > exynos-cpufreq to platform driver).
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Lukasz Majewski <l.majewski@samsung.com>
> > Cc: Tomasz Figa <t.figa@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/cpufreq/exynos-cpufreq.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> > index fcd2914d081a..fa54c2b88dd7 100644
> > --- a/drivers/cpufreq/exynos-cpufreq.c
> > +++ b/drivers/cpufreq/exynos-cpufreq.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/regulator/consumer.h>
> >  #include <linux/cpufreq.h>
> >  #include <linux/suspend.h>
> > +#include <linux/module.h>
> >  #include <linux/platform_device.h>
> 
> I am surprised how that patch went through then? And nothing was
> reported by kbuild for it..

Hi,

A little more explanation from my side: the build error actually happens
only on next/master, not Linus' tree.

Mentioned commit which changes the driver to platform driver is in
mainline since 3.12-rc2 so it seems this is not the cause of the build
error. I think I need to find first the real cause of this build error.

Best regards,
Krzysztof



