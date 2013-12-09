Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab3LINPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:15:00 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19163 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3LINO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:14:57 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-c6-52a5c24fa770
From: Tomasz Figa <t.figa@samsung.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Heiko Stuebner <heiko@sntech.de>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Andersen <dianders@chromium.org>
Subject: Re: [PATCH 1/3] ARM: EXYNOS: pmu: Constify data tables
Date: Mon, 09 Dec 2013 14:14:45 +0100
Message-id: <1922780.plAOmhqzpW@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1384971686-7208-1-git-send-email-djkurtz@chromium.org>
References: <1384971686-7208-1-git-send-email-djkurtz@chromium.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xy7oBh5YGGZxSsXi8ZjGTRcPVEItJ
	6w4wWZxddpDNonHGfFaL/49es1r0LrjKZrHp8TVWi8u75rBZzDi/j8ni9mVeB26PluYeNo/Z
	DRdZPP6uesHssXlJvUffllWMHtuvzWP2+LxJLoA9issmJTUnsyy1SN8ugStj5p3XTAUbWSuu
	7OlkaWD8x9zFyMkhIWAiseL3DXYIW0ziwr31bF2MXBxCAksZJX513WSBcLqYJPrmPWYDqWIT
	UJP43PAIyObgEBFQl/h1wwmkhlmgkVni1vP9TCA1wgL2EusmbwabyiKgKrHr6hwWkHpeAU2J
	A/tTQML8QK3vtj0FKxcVcJN4sW8LWDmngIvE5c+LwVYJCThLvJ17ixHE5hUQlPgx+R4LiM0s
	IC+xb/9UVghbS2L9zuNMExgFZyEpm4WkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLz
	czcxQiLmyw7GxcesDjEKcDAq8fCuYF0aJMSaWFZcmXuIUYKDWUmEV2wXUIg3JbGyKrUoP76o
	NCe1+BAjEwenVAOjXmi70ZargnJ7Z6/V37wvXlzOwnp+tflS5sRzez+YtuXtnPnrwlfBpVp3
	A6ZVfJP0nu95OiyoMf6d34TSp85Tp9hXFLjfnDbpVcHWQ8ZTk9foz9Cr8Dkue+vD6eJb0adl
	2CYHTy7p99/4/ZZi+Y7zF0/lXOP8ULGCWWjefanimro9pZL/lQpMlFiKMxINtZiLihMBqQ54
	rXYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thursday 21 of November 2013 02:21:24 Daniel Kurtz wrote:
> These tables are all immutable, make them const to save 4416 bytes of RAM.
> 
> size arch/arm/mach-exynos/pmu.o
>    text	   data	    bss
>     848	   4420	      4		// before
>    5264	      4	      4		// after

I'm not sure where the mentioned saving of RAM is. Moving data between
sections is not supposed to make it use less memory, I believe.

Anyway, it's a good practice to mark constant data as const, to disallow
changing them at runtime by mistake, so the patch is fine. Except some
issues I commented on inline.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

