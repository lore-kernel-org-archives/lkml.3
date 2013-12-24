Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3LXP1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:27:55 -0500
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:60412 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752308Ab3LXP1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:27:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:141:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:3873:4321:4605:5007:6119:7652:7903:8527:8603:8957:10004:10400:10848:11026:11232:11658:11914:12517:12519:12555:12740:13069:13161:13229:13255:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crack23_7edd6c8640c09
X-Filterd-Recvd-Size: 1863
Message-ID: <1387898870.2259.48.camel@joe-AO722>
Subject: Re: [PATCH 3/3] softirq: Use const char * const for
 softirq_to_name, whitespace neatening
From: Joe Perches <joe@perches.com>
To: Wang YanQing <udknight@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Dec 2013 07:27:50 -0800
In-Reply-To: <20131224151904.GA3398@udknight>
References: <cover.1384656563.git.joe@perches.com>
	 <ec5c256bd326246f4b12dde34455c1df9b71004d.1384656563.git.joe@perches.com>
	 <20131224151904.GA3398@udknight>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 23:19 +0800, Wang YanQing wrote:
> On Sun, Nov 17, 2013 at 01:55:12AM -0800, Joe Perches wrote:
> > Reduce data size a little.
> > Reduce checkpatch noise.
> > 
> > $ size kernel/softirq.o*
> >    text	   data	    bss	    dec	    hex	filename
> >   11554	   6013	   4008	  21575	   5447	kernel/softirq.o.new
> >   11474	   6093	   4008	  21575	   5447	kernel/softirq.o.old
> 
> Hi, could you tell me why this patch could reduce data size?

It moves the softirq_to_name array of 10 char *
from data (non-const) to text (const).

-char *softirq_to_name[NR_SOFTIRQS] = {
+const char * const softirq_to_name[NR_SOFTIRQS] = {
        "HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
        "TASKLET", "SCHED", "HRTIMER", "RCU"
 };

Use objdump or "make kernel/softirq.lst" and inspect
the object code produced to see for yourself.

cheers, Joe

