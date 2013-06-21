Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423340Ab3FUIYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:24:25 -0400
Received: from mx0.eldamar.org.uk ([78.47.157.133]:36124 "EHLO
	mx0.eldamar.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422707Ab3FUIYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:24:22 -0400
Date: Fri, 21 Jun 2013 09:24:08 +0100
From: Alexander Frolkin <avf@eldamar.org.uk>
To: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: SH fallback and L4 hashing
Message-ID: <20130621082408.GB23366@eldamar.org.uk>
References: <20130619095425.GA20145@eldamar.org.uk>
 <alpine.LFD.2.00.1306192239510.1823@ja.ssi.bg>
 <20130620132003.GD24993@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620132003.GD24993@verge.net.au>
X-GPG-Key-Fingerprint: 7820 960F C361 C9CE 401F  D07D 993A 2951 D970 4FA4
X-Operating-System: Linux 3.2.0-41-generic
X-Editor: Vi
X-Uptime: 09:37:38 up 38 days, 19:01,  9 users,  load average: 0.40, 0.40,
 0.33
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I also noticed some fuzz.
> Alexander, could you double-check ipvs-next to make sure
> that I applied the patch correctly?

I diff'ed my local dev branch with upstream, and the only thing I can
see that has any relation to my patches is:

diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
index b7e2c5a..f16c027 100644
--- a/net/netfilter/ipvs/ip_vs_sh.c
+++ b/net/netfilter/ipvs/ip_vs_sh.c
@@ -71,8 +71,8 @@ struct ip_vs_sh_bucket {
 #define IP_VS_SH_TAB_MASK               (IP_VS_SH_TAB_SIZE - 1)
 
 struct ip_vs_sh_state {
-       struct ip_vs_sh_bucket          buckets[IP_VS_SH_TAB_SIZE];
        struct rcu_head                 rcu_head;
+       struct ip_vs_sh_bucket          buckets[IP_VS_SH_TAB_SIZE];
 };
 
 /* Helper function to determine if server is unavailable */

Not sure when or why this changed, but maybe it accounts for the fuzz?


Alex

