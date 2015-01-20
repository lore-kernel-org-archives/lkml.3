Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbbATXVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:21:36 -0500
Received: from nacho.alt.net ([208.90.169.18]:53102 "EHLO nacho.alt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbbATXVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:21:31 -0500
Comment: DKIM? See http://www.dkim.org
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
	s=default; d=alt.net;
	h=Received:Received:Received:Date:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:X-Delivery-Agent:From:Reply-To;
	b=BPQP+foBnpIZLaTG5TH6uPuJpgmUItYAZBw0x2VCZP8AN/e5/0y5IlYMpQeAL3
	wTTAclWNZVkOeo9pyF5h/jD85Lcafo/0dQGMRNJH6XZrWIZQ82LrpLAXQV8jMZhV
	KfrP5OkVElQ5Tr9909FxZy8RXllnwsKkuLp+SAMFltrko=;
Date: Tue, 20 Jan 2015 23:21:30 +0000 (UTC)
To: Julian Anastasov <ja@ssi.bg>
cc: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] IPVS: add wlib & wlip schedulers
In-Reply-To: <alpine.LFD.2.11.1501192342190.2687@ja.home.ssi.bg>
Message-ID: <Pine.LNX.4.64.1501202320340.8217@nacho.alt.net>
References: <Pine.LNX.4.44.0501260832210.17893-100000@nacho.alt.net>
	<Pine.LNX.4.61.0502010007060.1148@penguin.linux-vs.org>
	<Pine.LNX.4.64.1501172217420.8217@nacho.alt.net>
	<alpine.LFD.2.11.1501192342190.2687@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Delivery-Agent: TMDA/1.1.12 (Macallan)
From: Chris Caputo <ccaputo@alt.net>
Reply-To: Chris Caputo <ccaputo-dated-1432164091.579f17@alt.net>
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
