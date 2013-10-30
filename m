Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3J3TnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:43:06 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35117 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3J3TnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:43:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
Cc: linux@arm.linux.org.uk, jiada_wang@mentor.com, kyungmin.park@samsung.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
Message-ID: <20131030194252.11662.92657@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v7 0/5] clk: clock deregistration support
Date: Wed, 30 Oct 2013 12:42:52 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sylwester Nawrocki (2013-10-29 12:51:03)
> This patch series implements clock deregistration in the common clock
> framework. Detailed changes are listed at each patch. I have included
> an additional patch in this series for the omap3isp driver, required 
> to avoid regressions.

Taken into clk-next. Thanks for the fine rework!

Regards,
Mike

> 
> Changes since v5:
>  - fixed NULL clock handling in __clk_get(), __clk_put (patch 5/5).
> 
> Changes since v4:
>  - removed stray struct module forward declaration in patch 3/5.
> 
> Changes since v3:
>  - replaced WARN_ON() with WARN_ON_ONCE() in clk_nodrv_disable_unprepare()
>    callback.
> 
> Changes since v2:
>  - reordered the patches so the race condition is fixed before it can
>    actually cause any issues,
>  - fixed handling of NULL clock pointers in __clk_get(), __clk_put(),
>  - added patch adding actual asignment of clk->owner; more details are
>    discussed in that specific patch.
> 
> Changes since v1:
>  - moved of_clk_{lock, unlock}, __of_clk_get_from_provider() function
>    declaractions to a local header,
>  - renamed clk_dummy_* to clk_nodrv_*.
> 
> Sylwester Nawrocki (5):
>   omap3isp: Modify clocks registration to avoid circular references
>   clk: Provide not locked variant of of_clk_get_from_provider()
>   clkdev: Fix race condition in clock lookup from device tree
>   clk: Add common __clk_get(), __clk_put() implementations
>   clk: Implement clk_unregister()
> 
>  arch/arm/include/asm/clkdev.h         |    2 +
>  arch/blackfin/include/asm/clkdev.h    |    2 +
>  arch/mips/include/asm/clkdev.h        |    2 +
>  arch/sh/include/asm/clkdev.h          |    2 +
>  drivers/clk/clk.c                     |  185 +++++++++++++++++++++++++++++++--
>  drivers/clk/clk.h                     |   16 +++
>  drivers/clk/clkdev.c                  |   12 ++-
>  drivers/media/platform/omap3isp/isp.c |   22 ++--
>  drivers/media/platform/omap3isp/isp.h |    1 +
>  include/linux/clk-private.h           |    5 +
>  include/linux/clkdev.h                |    5 +
>  11 files changed, 235 insertions(+), 19 deletions(-)
>  create mode 100644 drivers/clk/clk.h
> 
> -- 
> 1.7.9.5
