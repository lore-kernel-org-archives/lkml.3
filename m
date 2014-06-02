Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaFBNfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:35:18 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:61560 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaFBNfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:35:16 -0400
MIME-Version: 1.0
In-Reply-To: <537F082F.50501@suse.cz>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
	<1400233673-11477-1-git-send-email-vbabka@suse.cz>
	<CAGa+x87-NRyK6kUiXNL_bRNEGm+DR6M3HPSLYEoq4t6Nrtnd_g@mail.gmail.com>
	<CAAQ0ZWQDVxAzZVm86ATXd1JGUVoLXj_Y5Ske7htxH_6a4GPKRg@mail.gmail.com>
	<537F082F.50501@suse.cz>
Date: Mon, 2 Jun 2014 10:35:15 -0300
Message-ID: <CAOMZO5BKaicq7NkoJO4vU5W3hiDike6kSdH+2eD=h0B5BsDjTg@mail.gmail.com>
Subject: Re: [PATCH v2] mm, compaction: properly signal and act upon lock and
 need_sched() contention
From: Fabio Estevam <festevam@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Shawn Guo <shawn.guo@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Olof Johansson <olof@lixom.net>, Greg Thelen <gthelen@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vlastimil,

On Fri, May 23, 2014 at 5:34 AM, Vlastimil Babka <vbabka@suse.cz> wrote:

> Really sorry, guys :/
>
> -----8<-----
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Fri, 23 May 2014 10:18:56 +0200
> Subject: mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix2
>
> Step 1: Change function name and comment between v1 and v2 so that the return
>         value signals the opposite thing.
> Step 2: Change the call sites to reflect the opposite return value.
> Step 3: ???
> Step 4: Make a complete fool of yourself.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/compaction.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index a525cd4..5175019 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -237,13 +237,13 @@ static inline bool compact_should_abort(struct compact_control *cc)
>         if (need_resched()) {
>                 if (cc->mode == MIGRATE_ASYNC) {
>                         cc->contended = true;
> -                       return false;
> +                       return true;
>                 }
>
>                 cond_resched();
>         }
>
> -       return true;
> +       return false;
>  }

This patch is still not in linux-next.

Could you please submit it formally?
