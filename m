Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3JKUo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:44:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab3JKTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:39:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vimalkumar <j.vimal@gmail.com>, Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jiri Pirko <jpirko@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 014/110] net_sched: htb: fix a typo in htb_change_class()
Date: Fri, 11 Oct 2013 12:37:54 -0700
Message-Id: <20131011193809.166079056@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vimalkumar <j.vimal@gmail.com>

[ Upstream commit f3ad857e3da1abaea780dc892b592cd86c541c52 ]

Fix a typo added in commit 56b765b79 ("htb: improved accuracy at high
rates")

cbuffer should not be a copy of buffer.

Signed-off-by: Vimalkumar <j.vimal@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Jiri Pirko <jpirko@redhat.com>
Reviewed-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1476,7 +1476,7 @@ static int htb_change_class(struct Qdisc
 	psched_ratecfg_precompute(&cl->ceil, &hopt->ceil);
 
 	cl->buffer = PSCHED_TICKS2NS(hopt->buffer);
-	cl->cbuffer = PSCHED_TICKS2NS(hopt->buffer);
+	cl->cbuffer = PSCHED_TICKS2NS(hopt->cbuffer);
 
 	sch_tree_unlock(sch);
 


