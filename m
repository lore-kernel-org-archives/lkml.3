Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaEBFvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 01:51:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58929 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEBFva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 01:51:30 -0400
Date: Fri, 2 May 2014 06:51:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140502055127.GH18016@ZenIV.linux.org.uk>
References: <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
 <20140429181610.GJ18016@ZenIV.linux.org.uk>
 <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:15:15AM +0200, Miklos Szeredi wrote:
> On Tue, Apr 29, 2014 at 07:56:13PM -0700, Linus Torvalds wrote:
> > On Tue, Apr 29, 2014 at 7:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > OK, aggregate diff follows, more readable splitup (3 commits) attached.
> > > It seems to survive beating here; testing, review and comments are
> > > welcome.
> > 
> > Miklos, did you have some particular load that triggered this, or was
> > it just some reports? It would be really good to get this patch some
> > stress-testing.
> > 
> > I like how the patch removes more lines than it adds, but apart from
> > that it's hard to read the patch (even the split-out ones) and say
> > anything more about it. I think this needs a *lot* of testing.
> 
> IBM is triggering this with the host01 test from the LTP suite.  I haven't yet
> tried to reproduce it.

Could you repost their report?  So far I hadn't managed to get actual list
corruption on mainline kernel - it definitely is possible, but on all
testcases so far the race window is too narrow.  So if they have a reproducer
that doesn't take an insane amount of time, I'd really like to see it...
