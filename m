Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3AXUwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:52:38 -0500
Received: from relay3.sgi.com ([192.48.152.1]:46257 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755885Ab3AXUwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:52:30 -0500
Date: Thu, 24 Jan 2013 14:52:29 -0600
From: Robin Holt <holt@sgi.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Robin Holt <holt@sgi.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: How should I proceed to get commit 891348c to 3.0.y?
Message-ID: <20130124205229.GL3438@sgi.com>
References: <20130124152851.GF3460@sgi.com>
 <20130124181535.GB12106@kroah.com>
 <20130124183010.GF3438@sgi.com>
 <20130124200034.GB24705@kroah.com>
 <20130124201420.GI3438@sgi.com>
 <20130124205050.GA2206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124205050.GA2206@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 12:50:50PM -0800, Greg KH wrote:
> On Thu, Jan 24, 2013 at 02:14:20PM -0600, Robin Holt wrote:
> > On Thu, Jan 24, 2013 at 12:00:34PM -0800, Greg KH wrote:
> > > On Thu, Jan 24, 2013 at 12:30:10PM -0600, Robin Holt wrote:
> > > > On Thu, Jan 24, 2013 at 10:15:35AM -0800, Greg KH wrote:
> > > > > On Thu, Jan 24, 2013 at 09:28:51AM -0600, Robin Holt wrote:
> > > > > > 
> > > > > > I missed the email from 12/31 indicating commit 891348c was pulled from
> > > > > > the 3.0.y stable tree due to a build breakage.
> > > > > > 
> > > > > > That commit requires the enum defined in traps.h by commit c940826.  That,
> > > > > > in turn depends on commit 228bdaa95f which depends upon earlier commits.
> > > > > > 
> > > > > > How should I proceed?  Should I give you a patch that uses the constants
> > > > > > in xpc_main.c? Should I add a patch which just pulls the enum portion of
> > > > > > commit c940826 into traps.h? Any other direction you think this should go?
> > > > > 
> > > > > I think the last one makes the most sense as that makes it all
> > > > > self-contained and sensible, right?
> > > > 
> > > > git diff c940826~..c940826 -- arch/x86/include/asm/traps.h | patch -p1
> > > > git commit -a -c c940826
> > > > 
> > > > Then fixed it up to add a Signed-off-by: Robin Holt <holt@sgi.com>
> > > > 
> > > > I then did a make x86_64_defconfig, make menuconfig to get SGI_XP
> > > > selected.  I ran into a compile error where traps.h line 56 was failing
> > > > on __kprobes not being defined.  I added the #include <linux/kprobes.h>
> > > > and now it builds.
> > > > 
> > > > Here is the munged commit I currently have.  With that 891348c can be
> > > > cherry-picked and will build.  How should I proceed?  Is this enough
> > > > for you to make progress?  Should I clear out those Signed-off-by
> > > > lines for the submitter and HPA or should those stay?
> > > 
> > > They should stay.  resend this saying where the patch came from, and I
> > > will be glad to apply it.  Also tell me what the original patch you
> > > wanted me to apply was as well, I forgot it :)
> > 
> > I changed the "Author:" line to me and added my own Signed-off-by:
> > line.
> > 
> > The original commit which needed this fixup was 891348c
> > 
> > Thanks,
> > Robin
> > 
> > commit b4ff8081e86ebf7bb8c1d4c93dfaaf81a4539ee6
> > Author: Robin Holt <holt@sgi.com>
> > Date:   Fri Mar 9 16:07:10 2012 -0800
> > 
> >     x86: Use enum instead of literals for trap values [PARTIAL]
> >     
> >     The traps are referred to by their numbers and it can be difficult to
> >     understand them while reading the code without context. This patch adds
> >     enumeration of the trap numbers and replaces the numbers with the correct
> >     enum for x86.
> >     
> >     Signed-off-by: Kees Cook <keescook@chromium.org>
> >     Link: http://lkml.kernel.org/r/20120310000710.GA32667@www.outflux.net
> >     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> >     Signed-off-by: Robin Holt <holt@sgi.com>
> 
> No, don't loose the authorship info.
> 
> {sigh}
> 
> Ok, I've edited this up by hand and included it, and the original patch
> in the 3.0-stable tree, you should have an email about it now.  Please
> verify I got it all right.

That looks good to me.

Thank you,
Robin Holt
