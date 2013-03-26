Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3CZUZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:25:10 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39953 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3CZUZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:25:07 -0400
Date: Tue, 26 Mar 2013 13:25:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Kees Cook <keescook@chromium.org>,
        halfdog <me@halfdog.net>, P J P <ppandit@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH 42/88] exec: use -ELOOP for max recursion depth
Message-ID: <20130326202504.GE21624@kroah.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
 <1363257381-15900-43-git-send-email-luis.henriques@canonical.com>
 <1363661587.3937.360.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363661587.3937.360.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 02:53:07AM +0000, Ben Hutchings wrote:
> On Thu, 2013-03-14 at 10:35 +0000, Luis Henriques wrote:
> > 3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kees Cook <keescook@chromium.org>
> > 
> > commit d740269867021faf4ce38a449353d2b986c34a67 upstream.
> > 
> > To avoid an explosion of request_module calls on a chain of abusive
> > scripts, fail maximum recursion with -ELOOP instead of -ENOEXEC. As soon
> > as maximum recursion depth is hit, the error will fail all the way back
> > up the chain, aborting immediately.
> > 
> > This also has the side-effect of stopping the user's shell from attempting
> > to reexecute the top-level file as a shell script. As seen in the
> > dash source:
> > 
> >         if (cmd != path_bshell && errno == ENOEXEC) {
> >                 *argv-- = cmd;
> >                 *argv = cmd = path_bshell;
> >                 goto repeat;
> >         }
> > 
> > The above logic was designed for running scripts automatically that lacked
> > the "#!" header, not to re-try failed recursion. On a legitimate -ENOEXEC,
> > things continue to behave as the shell expects.
> > 
> > Additionally, when tracking recursion, the binfmt handlers should not be
> > involved. The recursion being tracked is the depth of calls through
> > search_binary_handler(), so that function should be exclusively responsible
> > for tracking the depth.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Cc: halfdog <me@halfdog.net>
> > Cc: P J P <ppandit@redhat.com>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [ luis: backport to 3.5 ]
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> [...]
> 
> Greg, I also included this in 3.2.y (commit 511d07b) but it is missing
> from 3.0.y and 3.4.y.  I hope one or other of these backports will be
> suitable for them (it was just a context fix for 3.2.y).

Applied, thanks.

greg k-h
