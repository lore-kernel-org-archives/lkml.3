Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaEGWfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:35:40 -0400
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:46660 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996AbaEGWfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:35:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2689:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:4321:5007:6119:7652:7774:7903:10004:10400:10562:10848:10967:11026:11232:11658:11914:12043:12517:12519:12555:12740:13069:13141:13161:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: run15_14006a06a3411
X-Filterd-Recvd-Size: 2105
Message-ID: <1399502135.6345.8.camel@joe-AO725>
Subject: Re: [PATCH 1/1] kernel/profile.c: use static const char instead of
 static char
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 07 May 2014 15:35:35 -0700
In-Reply-To: <20140507153050.70ad69194684f452bacc9bc8@linux-foundation.org>
References: <20140507223508.0fd3f59111f3d870859119fd@skynet.be>
	 <20140507153050.70ad69194684f452bacc9bc8@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-07 at 15:30 -0700, Andrew Morton wrote:
> On Wed, 7 May 2014 22:35:08 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> > schedstr, sleepstr and kvmstr are only used in strcmp & strlen
[]
> > +++ b/kernel/profile.c
> > @@ -52,9 +52,9 @@ static DEFINE_MUTEX(profile_flip_mutex);
> >  
> >  int profile_setup(char *str)
> >  {
> > -	static char schedstr[] = "schedule";
> > -	static char sleepstr[] = "sleep";
> > -	static char kvmstr[] = "kvm";
> > +	static const char schedstr[] = "schedule";
> > +	static const char sleepstr[] = "sleep";
> > +	static const char kvmstr[] = "kvm";
> >  	int par;
> >  
> 
> I'd expect this to either make no change or to make text larger and
> data smaller.
> 
> In fact,
> 
>    text    data     bss     dec     hex filename
>    7631     811    3016   11458    2cc2 kernel/profile.o-before
>    7520     779    3016   11315    2c33 kernel/profile.o-after
> 
> Both text and data got smaller and the total reduction was a whopping
> 143 bytes.   Weirdness.

Now there's no code required to initialize/memcpy
the strings every function invocation.


