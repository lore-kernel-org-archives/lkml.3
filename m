Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3AWGnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:43:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:18004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab3AWGnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:43:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,521,1355068800"; 
   d="scan'208";a="6633785"
Message-ID: <50FF8675.8050308@cn.fujitsu.com>
Date: Wed, 23 Jan 2013 14:43:01 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the akpm tree
References: <20130123173358.64b7d2cd01fde200225d46ec@canb.auug.org.au>
In-Reply-To: <20130123173358.64b7d2cd01fde200225d46ec@canb.auug.org.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 14:42:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 14:42:54,
	Serialize complete at 2013/01/23 14:42:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 02:33 PM, Stephen Rothwell wrote:
> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (arm defconfig)
> produced this warning:
>
> mm/page_alloc.c:4477:23: warning: 'sanitize_zone_movable_limit' defined but not used [-Wunused-function]
>
> Introduced by commit "page_alloc: introduce zone_movable_limit[] to keep
> movable limit for nodes" from the akpm tree.  It is defined both when
> CONFIG_HAVE_MEMBLOCK_NODE_MAP is defined and not, but only used if it is
> defined.
>

Hi Stephen,

Thank you for reporting this. :)

I was aware of this problem by the kbuild rebot, and I think this 
problem has been fixed
by the following patch I sent yesterday, and merged into -mm tree this 
morning.

Since I could access the lkml web site today, I cannot get an url for you.
Please tell me if your problem is not solved after applying this patch. :)

Thanks. :)


[PATCH Bug fix 3/4] Bug fix: Remove the unused 
sanitize_zone_movable_limit() definition.

When CONFIG_HAVE_MEMBLOCK_NODE_MAP is not defined, 
sanitize_zone_movable_limit()
is also not used. So remove it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
  mm/page_alloc.c |    5 -----
  1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cd6f8a6..2bd529e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4459,11 +4459,6 @@ static inline unsigned long __meminit 
zone_absent_pages_in_node(int nid,

  	return zholes_size[zone_type];
  }
-
-static void __meminit sanitize_zone_movable_limit(void)
-{
-}
-
  #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */

  static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
-- 1.7.1
