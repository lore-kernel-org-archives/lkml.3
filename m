Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3LELYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:24:00 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:37360
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab3LELX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:23:58 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh2327h2336h906i1155h)
From: Jagannadha Sutradharudu Teki 
	<jagannadha.sutradharudu-teki@xilinx.com>
To: <linux-kernel@vger.kernel.org>
CC: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
Subject: [PATCH] checkpatch: Do not hardcode perl path
Date: Thu, 5 Dec 2013 16:53:36 +0530
X-Mailer: git-send-email 1.8.3
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <b26e8934-caba-4385-bd32-8f48e2e99826@VA3EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl requires perl v5.10.0 to run but it
doesn't require to place in /usr/bin/perl
Use env to ensure that the interpreter used is the
first one on environment's $PATH on system with
several versions of perl installed.

Signed-off-by: Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
---
 scripts/checkpatch.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9c98100..241bb11 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1,10 +1,11 @@
-#!/usr/bin/perl -w
+#!/usr/bin/env perl
 # (c) 2001, Dave Jones. (the file handling bit)
 # (c) 2005, Joel Schopp <jschopp@austin.ibm.com> (the ugly bit)
 # (c) 2007,2008, Andy Whitcroft <apw@uk.ibm.com> (new conditions, test suite)
 # (c) 2008-2010 Andy Whitcroft <apw@canonical.com>
 # Licensed under the terms of the GNU GPL License version 2
 
+use warnings;
 use strict;
 use POSIX;
 
-- 
1.8.3


