Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbaGQOnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:43:09 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60020 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaGQOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:43:06 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5a-53c7e0f7fd16
Message-id: <53C7E0D2.1050307@samsung.com>
Date: Thu, 17 Jul 2014 16:42:26 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Chander Kashyap <k.chander@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: EXYNOS: Fix suspend/resume sequences
References: <53C51B57.9040404@samsung.com>
 <1405434287-22710-1-git-send-email-t.figa@samsung.com>
 <53C53A1A.6060701@samsung.com>
In-reply-to: <53C53A1A.6060701@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xy7rfHxwPNug+Y2qxccZ6Vot5n2Ut
	Vm1YwmKx5q+SRe+Cq2wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyWHvkLrvFql1/GB24PXbOusvu
	cefaHjaPzUvqPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvj9a/JjAWPuSu+n1jP2MB4jLOL
	kZNDQsBEouX6FkYIW0ziwr31bCC2kMBSRokjR0u7GLmA7M+MErNvTQIr4hXQklh2aj4ziM0i
	oCqxtusomM0moCbxueERWDM/UM2apussXYwcHKICERKPLwhBtApK/Jh8jwXEFgEq71m8lRFk
	PrPALmaJ91cnsoMkhAUcJd70P2eDWNwCtPjTXSaQBKeAtsScuQvBbGYBHYn9rdPYIGx5ic1r
	3jJPYBSchWTJLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREiFfdjAuPmZ1
	iFGAg1GJh7fz87FgIdbEsuLK3EOMEhzMSiK82fePBwvxpiRWVqUW5ccXleakFh9iZOLglGpg
	jLOyutTLNKuP9Xhr3bdnP7J91v8zt3eaO/mgD+9T9sVL5ysmtR9bkbRJO0OzTeAl95K7PzZo
	7Lqier37Fdfuw2E7H7v0rDB+u3vlptv3dJ7pNBcJ7D+17NjqL4bOs6ef9r1YJSK56W5pzUSe
	rFvhctV7boh23eypLbZdOVN8e8feTzoeS19I6iuxFGckGmoxFxUnAgDS+I6lbgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On 15.07.2014 16:26, Tomasz Figa wrote:
> Forgot to CC Daniel and linux-pm. Sorry for the noise.
> 
> On 15.07.2014 16:24, Tomasz Figa wrote:
>> Due to recent consolidation of Exynos suspend and cpuidle code, some
>> parts of suspend and resume sequences are executed two times, once from
>> exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
>> breaks suspend, at least on Exynos4-based boards. In addition, simple
>> core power down from a cpuidle driver could, in case of CPU 0 could
>> result in calling functions that are specific to suspend and deeper idle
>> states.
>>
>> This patch fixes the issue by moving those operations outside the CPU PM
>> notifier into suspend and AFTR code paths. This leads to a bit of code
>> duplication, but allows additional code simplification, so in the end
>> more code is removed than added.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> ---
>>  arch/arm/mach-exynos/pm.c        | 164 ++++++++++++++++++---------------------
>>  drivers/cpuidle/cpuidle-exynos.c |  25 +-----
>>  2 files changed, 80 insertions(+), 109 deletions(-)
>>

Please consider this patch for next pull request with rc fixes. It
replaces following patches posted in this thread:

[PATCH 5/6] ARM: EXYNOS: Fix suspend/resume sequencies
[PATCH v2 5/6] ARM: EXYNOS: Fix suspend/resume sequences

and also similar patch by Chander:

[PATCH 2/2] cpuidle: Exynos: fix cpuidle for all states

Best regards,
Tomasz
