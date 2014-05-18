Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaERNTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 09:19:16 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41374 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaERNTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 09:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <53742B55.1060507@lge.com>
References: <53742B55.1060507@lge.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 18 May 2014 21:18:54 +0800
Message-ID: <CAGsJ_4xXq++1KKMM5VjBCKbKGEWXK3QJK4R8-wzyURTcckxjpw@mail.gmail.com>
Subject: Re: [PATCH] [RFC] ARM: MM: remove phy_base field of struct
To: Gioh Kim <gioh.kim@lge.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        =?UTF-8?B?7J206rG07Zi4L+yxheyehOyXsOq1rOybkC9TVyBQbGF0Zm9ybSjsl7ApQU9U7YyAKGd1bmhvLmxlZUBs?=
	 =?UTF-8?B?Z2UuY29tKQ==?= <gunho.lee@lge.com>,
        gurugio@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-15 10:49 GMT+08:00 Gioh Kim <gioh.kim@lge.com>:
> Hi,
>
> It's not a big deal but I've found that phy_base field of struct
> l2x0_regs is not used anywhere.
> I've removed it on my board. It seems to be working fine.
>
> Why do we need physical address of L2 cache controller?
> Is it removable?

if you read the source codes of arch/arm/mach-imx/suspend-imx6.S, you
will find it is needed.

>
>
> ------------------------ 8< --------------------------
> From cc0d98f4ef8b6f8f139a7c6179ed0b03e9ad7d07 Mon Sep 17 00:00:00 2001
> From: Gioh Kim <gioh.kim@lge.com>
> Date: Thu, 15 May 2014 11:26:20 +0900
> Subject: [PATCH] [RFC] ARM: MM: remove phy_base field of struct l2x0_regs
>
> Remove unused field, phy_base of struct l2x0_regs
>
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> ---
>  arch/arm/include/asm/hardware/cache-l2x0.h |    1 -
>  arch/arm/kernel/asm-offsets.c              |    1 -
>  arch/arm/mm/cache-l2x0.c                   |    2 --
>  3 files changed, 4 deletions(-)
>
> diff --git a/arch/arm/include/asm/hardware/cache-l2x0.h
> b/arch/arm/include/asm/hardware/cache-l2x0.h
> index 6795ff7..6dec6da 100644
> --- a/arch/arm/include/asm/hardware/cache-l2x0.h
> +++ b/arch/arm/include/asm/hardware/cache-l2x0.h
> @@ -118,7 +118,6 @@ static inline int l2x0_of_init(u32 aux_val, u32
> aux_mask)
>  #endif
>
>  struct l2x0_regs {
> -       unsigned long phy_base;
>         unsigned long aux_ctrl;
>         /*
>          * Whether the following registers need to be saved/restored
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index 85598b5..9b0ff94 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -100,7 +100,6 @@ int main(void)
>    DEFINE(S_FRAME_SIZE,         sizeof(struct pt_regs));
>    BLANK();
>  #ifdef CONFIG_CACHE_L2X0
> -  DEFINE(L2X0_R_PHY_BASE,      offsetof(struct l2x0_regs, phy_base));
>    DEFINE(L2X0_R_AUX_CTRL,      offsetof(struct l2x0_regs, aux_ctrl));
>    DEFINE(L2X0_R_TAG_LATENCY,   offsetof(struct l2x0_regs, tag_latency));
>    DEFINE(L2X0_R_DATA_LATENCY,  offsetof(struct l2x0_regs, data_latency));
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index 7abde2c..728d644 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -985,8 +985,6 @@ int __init l2x0_of_init(u32 aux_val, u32 aux_mask)
>         if (!l2x0_base)
>                 return -ENOMEM;
>
> -       l2x0_saved_regs.phy_base = res.start;
> -
>         data = of_match_node(l2x0_ids, np)->data;
>
>         /* L2 configuration can only be changed if the cache is disabled */
> --
> 1.7.9.5

-barry
