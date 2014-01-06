Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbaAFWZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:25:50 -0500
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:60058 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755870AbaAFWZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:25:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6119:7652:8603:10004:10400:10848:11026:11232:11658:11914:12295:12296:12517:12519:12533:12740:13069:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: week65_152e3d2abd50b
X-Filterd-Recvd-Size: 2364
Message-ID: <1389047143.2433.14.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, pavel@ucw.cz, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 14:25:43 -0800
In-Reply-To: <201401070641.HAC18733.VOFMFOLOJQSFHt@I-love.SAKURA.ne.jp>
References: <201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
	 <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
	 <1388945392.5808.19.camel@joe-AO722>
	 <201401062300.GFE12908.FOQLFFJOSOMVHt@I-love.SAKURA.ne.jp>
	 <1389029698.2433.3.camel@joe-AO722>
	 <201401070641.HAC18733.VOFMFOLOJQSFHt@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 06:41 +0900, Tetsuo Handa wrote:
> Joe Perches wrote:
> > On Mon, 2014-01-06 at 23:00 +0900, Tetsuo Handa wrote:
> > > Joe Perches wrote:
> > > > Is this really necessary?
> > > No problem. %pT[012] are simply optimization (reducing number of function
> > > arguments for saving text size) and therefore I can drop them.
> > > What about below patch?
> > 
> > Hi Tetsuo.  Just a nit.
> > 
> > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > []
> > > @@ -1232,7 +1248,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> > >  {
> > >  	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
> > >  
> > > -	if (!ptr && *fmt != 'K') {
> > > +	if (!ptr && *fmt != 'K' && *fmt != 'T') {
> > 
> > I think this new 'T' comparison isn't necessary.
> 
> This is needed for allowing comm_name() to accept NULL instead of current.

Yeah, that's what I think isn't necessary.

current is current_thread_info()->task.

I think it's pretty lightweight in all arches and
it'd be simpler/more intelligible to not use NULL.

Andrew?  Any opinion?  Anyone else?

cheers, Joe

