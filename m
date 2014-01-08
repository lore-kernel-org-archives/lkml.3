Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbaAHOqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:46:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48787 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbaAHOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:46:27 -0500
Date: Wed, 8 Jan 2014 15:46:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: joe@perches.com, keescook@chromium.org, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
Message-ID: <20140108144625.GB14678@amd.pavel.ucw.cz>
References: <20140107001604.GD24243@amd.pavel.ucw.cz>
 <1389056635.2433.22.camel@joe-AO722>
 <20140107083740.GA5683@amd.pavel.ucw.cz>
 <1389116048.32137.14.camel@joe-AO722>
 <20140107175656.GB18316@amd.pavel.ucw.cz>
 <201401082319.FEC82827.JFFMOQSHOOVtFL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401082319.FEC82827.JFFMOQSHOOVtFL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-01-08 23:19:04, Tetsuo Handa wrote:
> Pavel Machek wrote:
> > > > > I'm not nacking this, just stating my view.
> > > > 
> > > > And I believe Andrew clearly stated his view, on the very topic you
> > > > asked him on.
> > > 
> > > I believe Andrew's view:
> > > 
> > > On Sat, 2013-12-28 at 12:08 -0800, Andrew Morton wrote:
> > > > On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:
> > > > > Tell me again, what's wrong with using p or current?
> > > > > printk("%pt", current);
> > > > 
> > > > Nothing much.  It's just that all these callsites are generating the
> > > > code to pass an argument which the callee already has access to. 
> > > > Optimizing that will reduce text size a bit.
> > > 
> > > was that the argument passing was the primary issue.
> > 
> > Yes. He dislikes passing argument callee has already access
> > to. "current". This patch does not do this, it just passes the NULL as
> > a marker... and to keep printf() checkers happy.
> 
> Excuse me?
> Compilers or kernel developers, which one does "printf() checkers" refer to?

Compilers.

> The "%pT" patch is for printing tsk->comm consistently, but not always
> tsk == current .

I like this one.

> The "\x1A" patch is for printing tsk->xxx without passing tsk->xxx as
> arguments, but always tsk == current .

I think this is not a good idea.

> Both patches are written not to confuse compilers when using
> __attribute__((format(printf, a, b))) check. Therefore, I don't think that
> the "\x1A" patch makes compilers unhappy. Rather, the "\x1A" patch would make
> compilers more happy because it replaces cost of passing current or NULL
> as arguments with cost of symbolic names (e.g. two bytes for
>   #define EMBED_CURRENT_COMM "\x1A\xFF"
> case) within the format string.

Agreed. No patches make compilers unhappy. I thought ("%pT", NULL) is
done that way not to confuse compilers. ("%pT") would trigger checks,
right?

> There might be kernel developers who are using \x1A within the format string as
> a literal byte, but we will be able to find and rewrite \x1A in the format
> string like

Yeah, but I still think magically replacing \x1A is unexpected
behaviour.

> It seems to me that we can agree with the "%pT" patch.

Yes.

> But how does the "\x1A" patch make compilers or kernel developers unhappy?

It makes me unhappy -- one more character to escape, and unexpected
one. (With possible security implications -- think sprintf(buf, "string
without %s, from user").

But in this thread, I was arguing that %pT is a good idea, should be
applied, and no more bike shedding is neccessary.

(Feel free to add  Acked-by:/Reviewed-by: Pavel Machek <pavel@ucw.cz>
if you wish.)

Thanks,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
