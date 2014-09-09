Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaIIDjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 23:39:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9183 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaIIDjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 23:39:39 -0400
X-AuditID: cbfee68d-f79c46d000000b84-a0-540e7678e116
From: kgene@kernel.org
To: "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Daniel Lezcano'" <daniel.lezcano@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com>
Subject: RE: [PATCH v5 RESEND 1/3] ARM: EXYNOS: Move code from hotplug.c to
 platsmp.c
Date: Tue, 09 Sep 2014 12:39:36 +0900
Message-id: <03a501cfcbdf$ad9f5680$08de0380$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIaHJFUvTQ7ohL8f4UGlA9SsK5Ti5tjhYsg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zI93KMr4Qg2+XmCw2zljPajHvs6zF
	6xeGFmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77BYn//QyWqza9YfRgdujpbmHzWPn
	rLvsHneu7WHz2Lyk3qNvyypGj8+b5ALYorhsUlJzMstSi/TtErgydhzfw1RwkL/iwO/LTA2M
	F3i6GDk5JARMJHbsu8gIYYtJXLi3nq2LkYtDSGAZo8S5P2uYYYoefPzKBJFYxChxbdpMdgjn
	L6PEwUnPgKo4ONiA2qc+kQZpEBbQkli4pYkFxBYROM4ocbYjGKSeWWA+k8S68wvZQBJCAu4S
	k9+tA9vAKeAh8bejmQWiOVzi2O6VYHEWAVWJQ6dng53HK2Ah0fLoOZQtKPFj8j2wemagZet3
	HmeCsOUlNq95C3W1gsSOs68ZIY4wkji2dBsjRI2IxL4X7xhBDpIQmMohsen6UXaIZQIS3yYf
	YgF5RkJAVmLTAag5khIHV9xgmcAoOQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelFxnqFSfm
	Fpfmpesl5+duYoSkgN4djLcPWB9iFOBgVOLhzQjmCxFiTSwrrsw9xGgKdNFEZinR5Hxgoskr
	iTc0NjOyMDUxNTYytzRTEudVlPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx2e+QWgvB
	2vY4NYHdrSZFPZNKZDR2TnvykLOwmjP29o8F09kXqk/Vkm6p7VbXq1K/uzUv89L0EAXd9s/d
	ZV6dMQ9uBN+zKJzBXi/qGPqq92PJZp3jhx0K5yyp/9QjlDSlptV9iaKyE6N35++QjxIruYRn
	r1gobTBxy9Sy79m2/MvOX2MQjVdiKc5INNRiLipOBADNDw3j/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd2KMr4Qg/tvrCw2zljPajHvs6zF
	6xeGFmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77BYn//QyWqza9YfRgdujpbmHzWPn
	rLvsHneu7WHz2Lyk3qNvyypGj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZuw4voep4CB/xYHfl5kaGC/wdDFyckgImEg8+PiVCcIWk7hwbz1bFyMXh5DAIkaJ
	a9NmskM4fxklDk56xtzFyMHBBlQ19Yk0SIOwgJbEwi1NLCC2iMBxRomzHcEg9cwC85kk1p1f
	yAaSEBJwl5j8bh0ziM0p4CHxt6OZBaI5XOLY7pVgcRYBVYlDp2czgti8AhYSLY+eQ9mCEj8m
	3wOrZwZatn7ncSYIW15i85q3zBBXK0jsOPuaEeIII4ljS7cxQtSISOx78Y5xAqPwLCSjZiEZ
	NQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4wz6R3MK5qsDjEKMDBqMTD
	mxHMFyLEmlhWXJl7iFGCg1lJhJchFijEm5JYWZValB9fVJqTWnyI0RTo04nMUqLJ+cDkl1cS
	b2hsYmZkaWRmYWRibq4kznuw1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgXH1uysRPKEFdhMb2l5a
	GNcHJ/7VWLPybN/BpKOJXRr/74YyaPzbcrrizjSxrczSczK3Zj1tMY6zDRXffzJ/vlLElAnv
	+OTq5m5IWM6wtStv2yQ+hy+869x/HF/idumDc07epBXX9Hy7Tk2zK/zxgXn750/tZ2TWi66o
	iHvN3S89ke3l1NNTFaSVWIozEg21mIuKEwFWfLUkRgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Kozlowski wrote:
> 
> Cleanup a little the SMP/hotplug code for Exynos by:
> 1. Moving completely all functions from hotplug.c into the platsmp.c;
> 2. Deleting the hotplug.c file.
> 
> After recent cleanups (e.g. 75ad2ab28f0f "ARM: EXYNOS: use
> v7_exit_coherency_flush macro for cache disabling") there was only CPU
> power down related code in hotplug.c file.
> 
> Rationale behind the code movement and benefits:
> 1. The file platsmp.c is the only user of code located in hotplug.c.
>    Keeping code in hotplug.c required declaring exynos_cpu_die() in common.h.
>    Such dependencies and mentioned exynos_cpu_die() declaration can be
>    removed.
> 2. In next patches exynos_set_delayed_reset_assertion() will be
>    introduced. This function will be called by:
>     - cpu_leave_power (hotplug.c),
>     - platform_do_lowpower (hotplug.c),
>     - exynos_boot_secondary (platsmp.c).
> 
> Merging hotplug.c into platsmp.c leads to simpler and cleaner code with
> less dependencies between files.
> 
> The commit only moves code around with one additional observable change:
> the hotplug.c was compiled with custom CFLAGS (-march=armv7-a). These
> CFLAGS are not necessary any more.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
> ---
> Changes since v4:
> 1. Rebase on linux-next-20140804.
> 2. Add Reviewed-by Tomasz Figa.
> ---
>  arch/arm/mach-exynos/Makefile  |  3 --
>  arch/arm/mach-exynos/common.h  |  2 -
>  arch/arm/mach-exynos/hotplug.c | 91 ------------------------------------------
>  arch/arm/mach-exynos/platsmp.c | 74 ++++++++++++++++++++++++++++++++++
>  4 files changed, 74 insertions(+), 96 deletions(-)
>  delete mode 100644 arch/arm/mach-exynos/hotplug.c

[...]

OK, I will take this series but I'm not sure what conflicts will be happened
with other pm related patches. If anything, I'll let you know ;)

Thanks,
Kukjin

