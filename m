Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbaFBPSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:18:36 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:55334 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaFBPSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:18:35 -0400
MIME-Version: 1.0
In-Reply-To: <538C8B45.6070803@suse.cz>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
	<1400233673-11477-1-git-send-email-vbabka@suse.cz>
	<CAGa+x87-NRyK6kUiXNL_bRNEGm+DR6M3HPSLYEoq4t6Nrtnd_g@mail.gmail.com>
	<CAAQ0ZWQDVxAzZVm86ATXd1JGUVoLXj_Y5Ske7htxH_6a4GPKRg@mail.gmail.com>
	<537F082F.50501@suse.cz>
	<CAOMZO5BKaicq7NkoJO4vU5W3hiDike6kSdH+2eD=h0B5BsDjTg@mail.gmail.com>
	<538C8B45.6070803@suse.cz>
Date: Mon, 2 Jun 2014 12:18:34 -0300
Message-ID: <CAOMZO5CCMwT9fPie1-JF+zqBfk4AYjuD43dwEEkRYqOjUPLN2w@mail.gmail.com>
Subject: Re: [PATCH -mm] mm, compaction: properly signal and act upon lock and
 need_sched() contention - fix
From: Fabio Estevam <festevam@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Kevin Hilman <khilman@linaro.org>,
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

On Mon, Jun 2, 2014 at 11:33 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> compact_should_abort() returns true instead of false and vice versa
> due to changes between v1 and v2 of the patch. This makes both async
> and sync compaction abort with high probability, and has been reported
> to cause e.g. soft lockups on some ARM boards, or drivers calling
> dma_alloc_coherent() fail to probe with CMA enabled on different boards.
>
> This patch fixes the return value to match comments and callers expecations.
>
> Reported-and-tested-by: Kevin Hilman <khilman@linaro.org>
> Reported-and-tested-by: Shawn Guo <shawn.guo@linaro.org>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
