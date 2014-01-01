Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaAAFtc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 1 Jan 2014 00:49:32 -0500
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:37318 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750970AbaAAFtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 00:49:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2740:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:4605:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12295:12517:12519:12533:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rings07_35bc0433c3656
X-Filterd-Recvd-Size: 2020
Message-ID: <1388555362.2259.38.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Date: Tue, 31 Dec 2013 21:49:22 -0800
In-Reply-To: <201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
References: <1388282837.24123.24.camel@joe-AO722>
	 <201312292113.FIJ60946.tFOVOJOHLQSFFM@I-love.SAKURA.ne.jp>
	 <1388422545.26796.36.camel@joe-AO722>
	 <201312311553.IGG09071.HLJtFVSQFFOOOM@I-love.SAKURA.ne.jp>
	 <1388507067.2259.24.camel@joe-AO722>
	 <201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-01 at 14:34 +0900, Tetsuo Handa wrote:
> I think we want formatting directive support because we have users shown below.
> 
>   fs/afs/internal.h:         printk("[%-6.6s] "FMT"\n", current->comm ,##__VA_ARGS__)
>   fs/cachefiles/internal.h:  printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)
>   fs/fscache/internal.h:     printk(KERN_DEBUG "[%-6.6s] "FMT"\n", current->comm, ##__VA_ARGS__)

Maybe, but I still think it's not particularly useful
and should not be possible/isn't necessary.

> This choice (i.e. reserve only '\xFF') is more resource economy than my
> previous choice (i.e. reserve '\x7F' to '\xFF') at the cost of wasting only
> one byte compared to my previous choice.

I supposed that's better.

Is there a particularly utility/reason to use 0xff
vs ascii SUB/PU1/PU2?


