Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaIPX4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:56:22 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:63043 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaIPX4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140916190329.GN22012@redacted.bos.redhat.com>
References: <20140916190329.GN22012@redacted.bos.redhat.com>
Date: Tue, 16 Sep 2014 19:56:19 -0400
Message-ID: <CADnq5_PLkwT_dAMunEFJ3B8PzNYyErXamCrcPijm4Lu76zFs_w@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: delete unused PTE_* defines
From: Alex Deucher <alexdeucher@gmail.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 3:03 PM, Kyle McMartin <kyle@redhat.com> wrote:
> They don't appear to be used anywhere... elsewhere uses R*_PTE_*.
>
> master@linux:U:.% git grep PTE_ -- drivers/gpu/drm/radeon | grep -v _PTE_
> master@linux:U:.%       (kyle@redacted:~/linux)
>
> ./arch/arm64/include/asm/pgtable.h:27:0: note: this is the location of the previous definition
>  #define PTE_VALID  (_AT(pteval_t, 1) << 0)
>  ^
> In file included from drivers/gpu/drm/radeon/r600_cs.c:31:0:
> drivers/gpu/drm/radeon/r600d.h:48:0: warning: "PTE_VALID" redefined [enabled by default]
>  #define PTE_VALID    (1 << 0)
>  ^
> In file included from ./arch/arm64/include/asm/io.h:29:0,
>                  from include/linux/clocksource.h:19,
>                  from include/clocksource/arm_arch_timer.h:19,
>                  from ./arch/arm64/include/asm/arch_timer.h:27,
>                  from ./arch/arm64/include/asm/timex.h:19,
>                  from include/linux/timex.h:65,
> <snip>
>                  from include/drm/drmP.h:51,
>                  from drivers/gpu/drm/radeon/r600_cs.c:29:
> ./arch/arm64/include/asm/pgtable.h:27:0: note: this is the location of the previous definition
>  #define PTE_VALID  (_AT(pteval_t, 1) << 0)
>  ^
>
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Applied.  thanks!

Alex

>
> --- a/drivers/gpu/drm/radeon/r600d.h
> +++ b/drivers/gpu/drm/radeon/r600d.h
> @@ -44,13 +44,6 @@
>  #define R6XX_MAX_PIPES                         8
>  #define R6XX_MAX_PIPES_MASK                    0xff
>
> -/* PTE flags */
> -#define PTE_VALID                              (1 << 0)
> -#define PTE_SYSTEM                             (1 << 1)
> -#define PTE_SNOOPED                            (1 << 2)
> -#define PTE_READABLE                           (1 << 5)
> -#define PTE_WRITEABLE                          (1 << 6)
> -
>  /* tiling bits */
>  #define     ARRAY_LINEAR_GENERAL              0x00000000
>  #define     ARRAY_LINEAR_ALIGNED              0x00000001
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
