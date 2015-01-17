Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbbAQXWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:22:52 -0500
Received: from nacho.alt.net ([208.90.169.18]:52282 "EHLO nacho.alt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbbAQXWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:22:51 -0500
Comment: DKIM? See http://www.dkim.org
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
	s=default; d=alt.net;
	h=Received:Received:Received:Date:To:cc:Subject:Message-ID:MIME-Version:Content-Type:X-Delivery-Agent:From:Reply-To;
	b=qZ4iX6QpsOf1mntk3TsHdnRL4UJ9upUWBx2P083Fgws4c+GBKtRL17WeWsbfS1
	qUF+m7f/U6ocWYbR6JX7Xi9S9aUB/zHplG0sxTc97jxVVlfpGzZepVRQuLiM5W5B
	I0HbbH83MtHPpzOs9S3Zst1MgoZGezHXBx2uidHg1VZBQ=;
Date: Sat, 17 Jan 2015 23:16:09 +0000 (UTC)
To: Wensong Zhang <wensong@linux-vs.org>, Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>
cc: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] IPVS: add wlib & wlip schedulers
Message-ID: <Pine.LNX.4.64.1501172310300.8217@nacho.alt.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Delivery-Agent: TMDA/1.1.12 (Macallan)
From: Chris Caputo <ccaputo@alt.net>
Reply-To: Chris Caputo <ccaputo-dated-1431904570.dcd98e@alt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Caputo <ccaputo@alt.net> 

IPVS wlib (Weighted Least Incoming Byterate) and wlip (Weighted Least Incoming 
Packetrate) scheduler docs for ipvsadm-1.27.

Signed-off-by: Chris Caputo <ccaputo@alt.net>
---
diff -upr ipvsadm-1.27-stock/SCHEDULERS ipvsadm-1.27/SCHEDULERS
--- ipvsadm-1.27-stock/SCHEDULERS	2013-09-06 08:37:27.000000000 +0000
+++ ipvsadm-1.27/SCHEDULERS	2015-01-17 22:14:32.812597191 +0000
@@ -1 +1 @@
-rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq
+rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq|wlib|wlip
diff -upr ipvsadm-1.27-stock/ipvsadm.8 ipvsadm-1.27/ipvsadm.8
--- ipvsadm-1.27-stock/ipvsadm.8	2013-09-06 08:37:27.000000000 +0000
+++ ipvsadm-1.27/ipvsadm.8	2015-01-17 22:14:32.812597191 +0000
@@ -261,6 +261,14 @@ fixed service rate (weight) of the ith s
 \fBnq\fR - Never Queue: assigns an incoming job to an idle server if
 there is, instead of waiting for a fast one; if all the servers are
 busy, it adopts the Shortest Expected Delay policy to assign the job.
+.sp
+\fBwlib\fR - Weighted Least Incoming Byterate: directs network
+connections to the real server with the least incoming byterate
+normalized by the server weight.
+.sp
+\fBwlip\fR - Weighted Least Incoming Packetrate: directs network
+connections to the real server with the least incoming packetrate
+normalized by the server weight.
 .TP
 .B -p, --persistent [\fItimeout\fP]
 Specify that a virtual service is persistent. If this option is
