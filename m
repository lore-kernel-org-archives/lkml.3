Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3ITSnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:43:15 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:57744 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753653Ab3ITSnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:43:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:599:857:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3868:3870:3872:3873:3874:4250:4321:4605:5007:6119:7652:7903:9389:10004:10400:10450:10455:10848:11232:11473:11658:11914:12043:12050:12262:12438:12517:12519:12555:12679:12740:13019:13069:13071:13161:13229:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dime44_559f2a9c3a216
X-Filterd-Recvd-Size: 2980
Message-ID: <1379702587.2301.12.camel@joe-AO722>
Subject: Re: [PATCH 2/2] framebuffer: Remove pmag-aa-fb
From: Joe Perches <joe@perches.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Date: Fri, 20 Sep 2013 11:43:07 -0700
In-Reply-To: <alpine.LFD.2.03.1309201907380.8379@linux-mips.org>
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
	 <6f500d88eb23fd9a4cfc5583f5ca17bc5f58fe24.1379641901.git.joe@perches.com>
	 <CAMuHMdW6R5qTJ0uvsUUaYBZAqFcNshPsXeMbz5hwqq5UOkJr-g@mail.gmail.com>
	 <alpine.LFD.2.03.1309201907380.8379@linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-20 at 19:18 +0100, Maciej W. Rozycki wrote:
> Joe, Geert --

Hi Maciej

> Can we please wait with that a few days?  I've been reviving DECstation 
> bits recently but the generic stuff took priority (thankfully little 
> bitrot there, the port generally works, except from the 64-bit mode).  I 
> think it'll make more sense if we have an incremental diff in the repo 
> rather than a complete removal, followed with a readdition with necessary 
> adjustments.

Good for you.

I do wonder how many of these still exist though.

I haven't had one of those on a desk since the early
'90's (a VAXstation w/VMS and a DECstation w/Ultrix)

This one's been dead for about that long too so
what's a little more time...

The commit that removed it was:
-------------------
commit c708093f8164011d01eb3bbdf7d61965f283ee0e
Author: James Simmons <jsimmons@maxwell.earthlink.net>
Date:   Wed Oct 30 20:06:21 2002 -0800

Moved all console configuration out of arch directories into
drivers/video/console. Allow resize of a single VC via the tty layer.
Nuked GET_FB_IDX.
-------------------

I think you could do:

---

 drivers/video/pmag-aa-fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/pmag-aa-fb.c b/drivers/video/pmag-aa-fb.c
index 8384248..0362fb7 100644
--- a/drivers/video/pmag-aa-fb.c
+++ b/drivers/video/pmag-aa-fb.c
@@ -459,7 +459,7 @@ static int __init init_one(int slot)
 		return -EINVAL;
 
 	printk(KERN_INFO "fb%d: %s frame buffer in TC slot %d\n",
-	       GET_FB_IDX(ip->info.node), ip->info.modename, slot);
+	       ip->info.node, ip->info.modename, slot);
 
 	return 0;
 }



