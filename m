Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaEWKtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:49:53 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:20663
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752863AbaEWKtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:49:50 -0400
Date: Fri, 23 May 2014 18:49:14 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Kevin Hilman <khilman@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "David Rientjes" <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, "Rik van Riel" <riel@redhat.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] mm, compaction: properly signal and act upon lock and
 need_sched() contention
Message-ID: <20140523104911.GA7306@dragon>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
 <1400233673-11477-1-git-send-email-vbabka@suse.cz>
 <CAGa+x87-NRyK6kUiXNL_bRNEGm+DR6M3HPSLYEoq4t6Nrtnd_g@mail.gmail.com>
 <CAAQ0ZWQDVxAzZVm86ATXd1JGUVoLXj_Y5Ske7htxH_6a4GPKRg@mail.gmail.com>
 <537F082F.50501@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <537F082F.50501@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130453157868795695;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(51704005)(199002)(24454002)(33656002)(92566001)(21056001)(57986005)(46102001)(76176999)(50466002)(99396002)(4396001)(81342001)(92726001)(80022001)(19580395003)(44976005)(23726002)(102836001)(26826002)(79102001)(77982001)(81542001)(83322001)(19580405001)(83072002)(85852003)(76482001)(97756001)(31966008)(87936001)(47776003)(46406003)(77096999)(33716001)(54356999)(50986999)(6806004)(20776003)(74662001)(74502001)(86362001)(83506001)(64706001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB010;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0220D4B98D
Authentication-Results: spf=softfail (sender IP is 192.88.168.1)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 10:34:55AM +0200, Vlastimil Babka wrote:
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

Tested-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  mm/compaction.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index a525cd4..5175019 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -237,13 +237,13 @@ static inline bool compact_should_abort(struct compact_control *cc)
>  	if (need_resched()) {
>  		if (cc->mode == MIGRATE_ASYNC) {
>  			cc->contended = true;
> -			return false;
> +			return true;
>  		}
>  
>  		cond_resched();
>  	}
>  
> -	return true;
> +	return false;
>  }
>  
>  /* Returns true if the page is within a block suitable for migration to */
> -- 
> 1.8.4.5
> 
> 
