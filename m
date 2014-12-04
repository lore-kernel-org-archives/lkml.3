Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaLDWnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:43:51 -0500
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:54438 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753262AbaLDWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:43:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3868:3870:3872:3874:4321:4605:5007:6119:6120:6261:7901:7903:8603:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12555:12740:13019:13069:13146:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wing68_421e7b50273b
X-Filterd-Recvd-Size: 2471
Message-ID: <1417733027.2721.19.camel@perches.com>
Subject: Re: tinyconfig x86-32 vmlinux sizes by gcc compiler version
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 04 Dec 2014 14:43:47 -0800
In-Reply-To: <20141204222521.GA20091@cloud>
References: <1417728779.2721.15.camel@perches.com>
	 <20141204222521.GA20091@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 14:25 -0800, josh@joshtriplett.org wrote:
> On Thu, Dec 04, 2014 at 01:32:59PM -0800, Joe Perches wrote:
> > Just fyi.
> > 
> > At least for x86-32, it seems later versions of gcc
> > are producing smaller images.
> > 
> > $ size vmlinux.*
> >    text	   data	    bss	    dec	    hex	filename
> >  657725	 118496	1189040	1965261	 1dfccd	vmlinux.4.4
> >  633563	 118528	1189448	1941539	 1da023	vmlinux.4.6
> >  633277	 118496	1189592	1941365	 1d9f75	vmlinux.4.7
> >  632299	 121120	1192784	1946203	 1db25b	vmlinux.4.9
> 
> I would certainly hope that GCC's -Os gets better over time.  However, I
> find the increase in data/bss and thus overall size in 4.9 concerning.
> Any idea what that comes from?

No.

It's all over the place.

For instance:

$ objdump -t vmlinux.4.7 | awk '{if (NF>=2) {print $(NF) "\t" $(NF-1)}}' | sort > 4.7
$ objdump -t vmlinux.4.9 | awk '{if (NF>=2) {print $(NF) "\t" $(NF-1)}}' | sort > 4.9

$ diff -u0 -rN 4.7 4.9 | wc -l
6944

$ diff -u0 -rN 4.7 4.9 | head -20
--- 4.7 2014-12-04 14:34:41.455533301 -0800
+++ 4.9 2014-12-04 14:34:16.703531656 -0800
@@ -5 +5 @@
-access_process_vm      00000040
+access_process_vm      0000003e
@@ -9,3 +9,2 @@
-account_event_cpu.isra.57      0000001f
-account_event.part.60  00000065
-account_group_user_time        0000001f
+account_event_cpu.isra.56      0000001f
+account_event.part.61  00000069
@@ -14,2 +13 @@
-account_kernel_stack   00000029
-account_page_dirtied   00000052
+account_page_dirtied   0000005f
@@ -20,2 +18,2 @@
-account_system_time    000000e3
-account_user_time      00000047
+account_system_time    0000010d
+account_user_time      0000005d



