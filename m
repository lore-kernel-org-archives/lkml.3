Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3GKRXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 13:23:03 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64243 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3GKRXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 13:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <002801ce797b$3d2fbc80$b78f3580$@samsung.com>
References: <002801ce797b$3d2fbc80$b78f3580$@samsung.com>
Date: Thu, 11 Jul 2013 10:22:59 -0700
X-Google-Sender-Auth: 9_dlFFimTgtTt1NhWXZBcHWVqdE
Message-ID: <CANEJEGvajhgzUPG6ppbjwBb4-9TdU9em3T_SejBpz8NCjGHYTQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
From: Grant Grundler <grundler@chromium.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 5, 2013 at 5:29 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> The current exynos-iommu(System MMU) driver does not work autonomously
> since it is lack of support for power management of peripheral blocks.
...
> Patch summary:
> [PATCH v7 1/9] iommu/exynos: do not include removed header
> [PATCH v7 2/9] iommu/exynos: add missing cache flush for removed page table entries
> [PATCH v7 3/9] iommu/exynos: fix page table maintenance
> [PATCH v7 4/9] iommu/exynos: allocate lv2 page table from own slab
> [PATCH v7 5/9] iommu/exynos: change rwlock to spinlock
> [PATCH v7 6/9] clk: exynos5250: add gate clock descriptions of System MMU
> [PATCH v7 7/9] ARM: dts: Add description of System MMU of Exynos SoCs
> [PATCH v7 8/9] iommu/exynos: support for device tree
> [PATCH v7 9/9] iommu/exynos: add bus notifier for registering System MMU

Cho,
Of the above patches, nearly all have been applied to chromeos-3.8
(kernel-next git tree) by Doug Anderson and others.

AFAICT, the only ones not applied are:
   [v7,3/9] iommu/exynos: fix page table maintenance
   [v7,6/9] clk: exynos5250: add gate clock descriptions of System MMU
(conflicts in this one)
   [v7,7/9] ARM: dts: Add description of System MMU of Exynos SoCs
(depends on 6/9)

We also already have parts of:
   [v7,9/9] iommu/exynos: add bus notifier for registering System MMU

Some of those are being further discussed but I've lost track now
exactly which ones.

I'm telling you about chromeos-3.8 status since the adopted changes
have been reviewed (by me and others) are being tested manually here
on several different Samsung Exynos platforms (including 5250 which is
our "snow" platform). Not sure how you should to mark those patches
since they aren't identical to your changes (which apply to post 3.10
kernels, not 3.8).  You might consider splitting those patches out
from the 4 I've listed above to get that series accepted upstream
since the additional review/testing should provide some confidence
those patches are good.

cheers,
grant
