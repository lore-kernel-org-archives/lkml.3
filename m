Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaGLRvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 13:51:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaGLRu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 13:50:57 -0400
Date: Sat, 12 Jul 2014 10:55:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
Message-ID: <20140712175526.GA17077@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712013444.GA30368@kroah.com>
 <1405129216.6751.18.camel@joe-AO725>
 <20140712093043.GG25880@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712093043.GG25880@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 12:30:43PM +0300, Dan Carpenter wrote:
> On Fri, Jul 11, 2014 at 06:40:16PM -0700, Joe Perches wrote:
> > On Fri, 2014-07-11 at 18:34 -0700, Greg KH wrote:
> > > On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> > > > A simple script to run checkpatch --fix for various types of
> > > > of cleanups.
> > > > 
> > > > This script is useful primarily for staging.
> > > > 
> > > > This reformats code to a more CodingStyle conforming style,
> > > > compiles it, verifies that the object code hasn't changed,
> > > > and git commits it too.
> > > 
> > > And 'git commits' it?
> > 
> > The thought I had was to made it easier to
> > submit "my first kernel patch" correctly.
> > like that tuxradar article you wrote a few
> > years ago.
> > 
> > http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel
> > 
> > > Heh, I should just run this myself to clean up
> > > staging and beat everyone else to it...
> > 
> > At least for the whitespace noise, you could
> > but I hope it'll encourage a few more people
> > to try kernel patching instead.
> 
> I have always hate the idea of automated patches from random people
> because I don't trust them to not be malicious so I have to review them
> manually.  There is a story that back in the day the US government paid
> someone to send tons of checkpatch style patches to BSD.  The guy
> thought he was "cleaning up the code" but actually he was part of a
> larger scheme to flood the maintainers with patches so another person
> could slip in some malicious code.

Based on some of the patches that I get sent, I wouldn't be surprised if
that's already happening :(

> It's better if someone just ran this on all new staging code before
> adding it to the tree.

I spent some time messing with this script today, and while it is "fun"
to run, I don't think it's all that useful.

One example, before running the script:

~/linux/work/staging $ ./scripts/checkpatch.pl --terse --file drivers/staging/android/binder.c | tail -n 1
total: 0 errors, 103 warnings, 3670 lines checked

After running it:

~/linux/work/staging $ ./scripts/checkpatch.pl --terse --file drivers/staging/android/binder.c | tail -n 1
total: 0 errors, 125 warnings, 3670 lines checked

And that was after the script created two patches, with the resulting
diffstat of:

 drivers/staging/android/binder.c |  124 +++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

So 2 patches, 60+ lines to review, and 22 more warnings from checkpatch
as the end result?

Yes, the warnings are all due to line-length, but Joe, you shouldn't add
a patch that causes more checkpatch warnings than before :)


I know people have scripts like this of their own, and while it might be
nice to "standardize" them, I am really reluctant to put this script in
the kernel tree itself.  There's a barrier of entry to write your own
type of script here that honestly, I like.

We already have the example of someone who obviously does not know the C
language at all, running through the kernel tree at the moment, creating
horrible patches that are flat-out wrong and annoying maintainers with
their result.  I've had to kill-file them for now, as it was just too
annoying and maintainer time is what we have the least of.

While I always want to see more developers get involved with kernel
development, there should be a minimum barrier to entry.  And that
barrier is the knowledge of the C language, and knowledge of how to edit
a text file, and use git.  This script takes that barrier away, for
whitespace cleanups, with not much real use overall.

So, I'll keep my local copy of this script now, just to have fun with at
times when I'm bored.  But I don't think it should be merged, as-is.

thanks,

greg k-h
