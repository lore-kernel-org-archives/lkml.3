Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3BFFW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:22:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab3BFFWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:22:22 -0500
X-IronPort-AV: E=Sophos;i="4.84,613,1355068800"; 
   d="scan'208";a="6694967"
Message-ID: <5111E82E.90202@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 13:20:46 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] net: change type of netns_ipvs->sysctl_sync_qlen_max
References: <5111E612.4010907@cn.fujitsu.com>
In-Reply-To: <5111E612.4010907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 13:21:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 13:21:03,
	Serialize complete at 2013/02/06 13:21:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This member of struct netns_ipvs is calculated from nr_free_buffer_pages
so change its type to unsigned long in case of overflow.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/net/ip_vs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 68c69d5..66e6c01 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -966,7 +966,7 @@ struct netns_ipvs {
 	int			sysctl_snat_reroute;
 	int			sysctl_sync_ver;
 	int			sysctl_sync_ports;
-	int			sysctl_sync_qlen_max;
+	unsigned long		sysctl_sync_qlen_max;
 	int			sysctl_sync_sock_size;
 	int			sysctl_cache_bypass;
 	int			sysctl_expire_nodest_conn;
-- 
1.7.1
