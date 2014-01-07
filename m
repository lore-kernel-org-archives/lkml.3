Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbaAGAQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:16:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52001 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbaAGAQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:16:06 -0500
Date: Tue, 7 Jan 2014 01:16:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org,
        akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-ID: <20140107001604.GD24243@amd.pavel.ucw.cz>
References: <201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
 <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
 <1388945392.5808.19.camel@joe-AO722>
 <201401062300.GFE12908.FOQLFFJOSOMVHt@I-love.SAKURA.ne.jp>
 <1389029698.2433.3.camel@joe-AO722>
 <201401070641.HAC18733.VOFMFOLOJQSFHt@I-love.SAKURA.ne.jp>
 <1389047143.2433.14.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389047143.2433.14.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > > []
> > > > @@ -1232,7 +1248,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> > > >  {
> > > >  	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
> > > >  
> > > > -	if (!ptr && *fmt != 'K') {
> > > > +	if (!ptr && *fmt != 'K' && *fmt != 'T') {
> > > 
> > > I think this new 'T' comparison isn't necessary.
> > 
> > This is needed for allowing comm_name() to accept NULL instead of current.
> 
> Yeah, that's what I think isn't necessary.
> 
> current is current_thread_info()->task.
> 
> I think it's pretty lightweight in all arches and
> it'd be simpler/more intelligible to not use NULL.
> 
> Andrew?  Any opinion?  Anyone else?

Andrew was worried about all the "current" duplication, IIRC. It is in
the mail thread somewhere. And one condition in printk is price worth paying.
    	 		       	   	     	       	  	      Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
