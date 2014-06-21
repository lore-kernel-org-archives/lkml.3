Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaFUOKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 10:10:12 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:58252 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752173AbaFUOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 10:10:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:965:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:4385:4390:4395:5007:6119:7652:8531:10004:10400:10848:10967:11232:11658:11914:12517:12519:12663:12740:13069:13095:13141:13230:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: vein21_758bf7567ac4c
X-Filterd-Recvd-Size: 2373
Message-ID: <1403359806.4076.50.camel@joe-AO725>
Subject: Re: [PATCH 1/1] net/dsa/dsa.c: remove null test before kfree
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>, netdev@vger.kernel.org
Date: Sat, 21 Jun 2014 07:10:06 -0700
In-Reply-To: <20140621113653.6b2dd148b35a6ecfb7c08cce@skynet.be>
References: <1403296607-6065-1-git-send-email-fabf@skynet.be>
	 <b991e868-c253-4b1a-8c95-56106c36d512@email.android.com>
	 <20140621113653.6b2dd148b35a6ecfb7c08cce@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-21 at 11:36 +0200, Fabian Frederick wrote:
> On Sat, 21 Jun 2014 10:37:24 +0200 Bjørn Mork <bjorn@mork.no> wrote:
> > On 20 June 2014 22:36:47 CEST, Fabian Frederick <fabf@skynet.be> wrote:
> > > Fix checkpatch warning:
> > > WARNING: kfree(NULL) is safe this check is probably not required
> > 
> > "probably not" implies that there are cases where the check *is*
> > required.  That means that your commit message should explain why
> > this particular check is redundant.
> > 
> > I haven't analyzed your changes here, so they could be fine for all
> > I know. My point is that such analysis is your job when submitting
> > cleanups like this one.
> AFAIK, any
> 
> if(foo)
> 	kfree(foo)
> 	
> can be updated to kfree(foo) but
> 
> if (foo){
> 	kfree(foo)
> 	do something else
> }
> 
> has to be evaluated ; reason for the "probably" in warning message.
> If I'm wrong maybe we could be more verbose in checkpatch :)

I think Bjørn is correct here.

Just because checkpatch bleats some message or another,
it's still the submitter's job to validate the code.

In this case, it seems the simple substitution of
"unnecessary null" to the subject would have been
enough validation.

I don't think checkpatch needs updating for this, but
maybe you could propose better language.

