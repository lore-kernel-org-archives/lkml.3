Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaBUXWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:22:39 -0500
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:56377 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751686AbaBUXWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:22:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3740:3865:3866:3868:3872:5007:6119:6120:7652:7901:7903:10004:10400:10848:11658:11914:12517:12519:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: steam28_8b122e006015b
X-Filterd-Recvd-Size: 1066
Message-ID: <1393024954.2594.35.camel@joe-AO722>
Subject: printk and kdb - dev_<level> not trapped/forwarded
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Jason Wessel <jason.wessel@windriver.com>
Date: Fri, 21 Feb 2014 15:22:34 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> output does not use printk() but directly
calls vprintk_emit().

kdb only traps direct printk() calls.

So, kdb hasn't emitted any dev_<level> or netdev_<level>
output since structured logging and vprintk_emit() was
introduced a couple of years ago.

It seems no one has cared.

Maybe the kdb handling should be removed?

