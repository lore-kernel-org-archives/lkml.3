Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3KEFyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 00:54:31 -0500
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:47014 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750759Ab3KEFya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 00:54:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4250:4321:4425:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12555:12679:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toys34_7e78edfa3cb04
X-Filterd-Recvd-Size: 2283
Message-ID: <1383630867.4387.11.camel@joe-AO722>
Subject: Re: [PATCH -next] get_maintainer: Improve "Author:" rolestats
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Nov 2013 21:54:27 -0800
In-Reply-To: <52788606.5070002@asianux.com>
References: <52738E90.6040104@asianux.com>
	 <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com>
	 <1383602096.28651.8.camel@joe-AO722> <52785676.8030801@asianux.com>
	 <527859D9.30109@asianux.com> <1383629008.4387.0.camel@joe-AO722>
	 <5278853E.2000600@asianux.com> <52788606.5070002@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 13:45 +0800, Chen Gang wrote:
> If really as what I guess above (some patches no Signed-of-by), is there
> a tool to check and find this issue in time?

scripts/checkpatch.pl bleats a message on missing sign-offs.

For instance:

$ cat cache.diff
 include/linux/cache.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cache.h b/include/linux/cache.h
index 4c57065..17e7e82 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -1,11 +1,11 @@
 #ifndef __LINUX_CACHE_H
 #define __LINUX_CACHE_H
 
-#include <linux/kernel.h>
+#include <uapi/linux/kernel.h>
 #include <asm/cache.h>
 
 #ifndef L1_CACHE_ALIGN
-#define L1_CACHE_ALIGN(x) ALIGN(x, L1_CACHE_BYTES)
+#define L1_CACHE_ALIGN(x) __ALIGN_KERNEL(x, L1_CACHE_BYTES)
 #endif
 
 #ifndef SMP_CACHE_BYTES

$ ./scripts/checkpatch.pl cache.diff
ERROR: Missing Signed-off-by: line(s)

total: 1 errors, 0 warnings, 13 lines checked

cache.diff has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


