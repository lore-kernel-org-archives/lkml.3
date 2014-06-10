Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaFJXoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:44:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39304 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFJXow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:44:52 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-d1-53979872daef
Message-id: <53979871.2020903@samsung.com>
Date: Wed, 11 Jun 2014 08:44:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] ARM: EXYNOS: Fix the sequence of secondary CPU boot
 for Exynos3250
References: <1402442827-2321-1-git-send-email-cw00.choi@samsung.com>
 <5397963F.30109@gmail.com>
In-reply-to: <5397963F.30109@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWyRsSkWLdoxvRgg5n/xC16F1xlszjb9Ibd
	YtPja6wWl3fNYbOYcX4fk8Xty7wW62e8ZrFYtesPowOHR0tzD5vHzll32T02L6n36NuyitHj
	8ya5ANYoLpuU1JzMstQifbsEroznSzayF3ziqbi6eTNrA+MTri5GTg4JAROJo6tms0PYYhIX
	7q1n62Lk4hASWMoocbC/nwWm6Nmmt4wQiUWMEt8vL2CCcF4zSsw7eJYRpIpXQEtiyo13YB0s
	AqoSHz9sBxvLBhTf/+IGG4gtKhAmsXL6FRaIekGJH5PvgdkiAuoS36b0s4MMZRY4zSix+P9h
	1i5GDg5hgQSJzb1KIDVCAokSHe+us4CEOYHqV140BwkzC+hI7G+dxgZhy0tsXvOWGWSMhMA1
	donDG5exQtwjIPFt8iGwXgkBWYlNB5ghHpOUOLjiBssERrFZSC6ahWTsLCRjFzAyr2IUTS1I
	LihOSi8y1StOzC0uzUvXS87P3cQIjL7T/55N3MF4/4D1IcZkoJUTmaVEk/OB0ZtXEm9obGZk
	YWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxmzyxtGzKkT1cF
	1j2V9Wt6wbh4I+vCWbZCFsYZhfJOrJucss+n3J3NvC3px3OTbPvdnoWJJ3a7y1Z9/b0i4OqK
	N6uv6deYrFP9k/pkQ8KszlcZJW4fmRMnHzRuepZ0qZ+psS8yk1Psv+G8BzL65zs1hd0kDspe
	EZrw6cFaqaWFjlMO+q8qnqrEUpyRaKjFXFScCACmYa+G1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd2iGdODDZb/57foXXCVzeJs0xt2
	i02Pr7FaXN41h81ixvl9TBa3L/NarJ/xmsVi1a4/jA4cHi3NPWweO2fdZffYvKTeo2/LKkaP
	z5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmPF+ykb3gE0/F1c2b
	WRsYn3B1MXJySAiYSDzb9JYRwhaTuHBvPVsXIxeHkMAiRonvlxcwQTivGSXmHTwLVsUroCUx
	5cY7FhCbRUBV4uOH7ewgNhtQfP+LG2wgtqhAmMTK6VdYIOoFJX5MvgdmiwioS3yb0s8OMpRZ
	4DSjxOL/h1m7GDk4hAUSJDb3KoHUCAkkSnS8u84CEuYEql950RwkzCygI7G/dRobhC0vsXnN
	W+YJjAKzkGyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY/uZ1A7GlQ0W
	hxgFOBiVeHgPSEwPFmJNLCuuzD3EKMHBrCTCa5MGFOJNSaysSi3Kjy8qzUktPsSYDAyAicxS
	osn5wLSTVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUsAE9ClC
	7s26GF/lX653TJ4USlY9q+0J/7Y4Zj5P+PvvM6XE7O47rthUE+R1cjaH+q9j6g/5b3HODVmU
	PIMtfofkj/X5PJfXlgdus+yd2nvlZvdBoyPWl5+3beArt+jt+n796NWFs5YEmLxfVmO4x+re
	sW0nr5e8irxm1d2ofFv1l9BruePXFJvClFiKMxINtZiLihMBmfm1GzEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 08:35 AM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 11.06.2014 01:27, Chanwoo Choi wrote:
>> This patch set AUTOWAKEUP_EN bit to ARM_CORE_CONFIGURATION register
>> because Exynos3250 removes WFE in secure mode so that turn on automatically
>> after setting CORE_LOCAL_PWR_EN. Also, This patch use dbs_sev() macro
>> to guarantee the data synchronization of command instead of IPI_WAKEUP
>> because Exynos3250 don't have WFE mode in secue mode.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-exynos/platsmp.c  | 9 ++++++++-
>>  arch/arm/mach-exynos/pm.c       | 8 ++++++--
>>  arch/arm/mach-exynos/regs-pmu.h | 4 ++++
>>  3 files changed, 18 insertions(+), 3 deletions(-)
>>
> 
> This patch seems to be unneeded with Krzysztof's patch send a while ago
> [1]. As reported by Krzysztof, that patch apparently fixes SMP support
> on Exynos3250 and is much smaller and less invasive.
> 
> [1] - http://thread.gmane.org/gmane.linux.kernel.samsung-soc/32809

OK,
But Krzysztof's patch didn't include set S5P_CORE_AUTOWAKEUP_EN in EXYNOS_ARM_CORE_CONFIGURATION(cpu).
and then use arch_send_wakeup_ipi_mask(cpumask_of(cpu)) command instead of dsb_sev(). Exynos3250 don't need
send IPI message.

I'll send next patch which include only S5P_CORE_AUTOWAKEUP_EN and without sending IPI message.

Krzysztof's patch used of_machine_is_compatible("samsung,exynos3250") instead of soc_is_exynos3250().
Did you agree? If you agree to use of_machine_is_compatible(), I'll use it on next patch(v2).

Best Regards,
Chanwoo Choi

