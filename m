Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaAGR5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:57:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbaAGR46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:56:58 -0500
Date: Tue, 7 Jan 2014 18:56:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org,
        akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-ID: <20140107175656.GB18316@amd.pavel.ucw.cz>
References: <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
 <1388945392.5808.19.camel@joe-AO722>
 <201401062300.GFE12908.FOQLFFJOSOMVHt@I-love.SAKURA.ne.jp>
 <1389029698.2433.3.camel@joe-AO722>
 <201401070641.HAC18733.VOFMFOLOJQSFHt@I-love.SAKURA.ne.jp>
 <1389047143.2433.14.camel@joe-AO722>
 <20140107001604.GD24243@amd.pavel.ucw.cz>
 <1389056635.2433.22.camel@joe-AO722>
 <20140107083740.GA5683@amd.pavel.ucw.cz>
 <1389116048.32137.14.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389116048.32137.14.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > I'm not nacking this, just stating my view.
> > 
> > And I believe Andrew clearly stated his view, on the very topic you
> > asked him on.
> 
> I believe Andrew's view:
> 
> On Sat, 2013-12-28 at 12:08 -0800, Andrew Morton wrote:
> > On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:
> > > Tell me again, what's wrong with using p or current?
> > > printk("%pt", current);
> > 
> > Nothing much.  It's just that all these callsites are generating the
> > code to pass an argument which the callee already has access to. 
> > Optimizing that will reduce text size a bit.
> 
> was that the argument passing was the primary issue.

Yes. He dislikes passing argument callee has already access
to. "current". This patch does not do this, it just passes the NULL as
a marker... and to keep printf() checkers happy.

I believe this is way better than alternatives.

> Now that that's not done, this code actually uses a
> different concept, that "NULL" is special when using
> %pT.  If the argument isn't eliminated all together,
> I think that new concept should be avoided.
> 
> The additional cost of using current vs NULL is ~zero.

The additional cost of current vs NULL is cca 8 bytes per caller. Test
for NULL is cca 4 bytes, maybe 20 bytes total. I believe it is worth
it.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
