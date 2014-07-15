Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbaGOKF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:05:59 -0400
Received: from smtp2.macqel.be ([109.135.2.61]:49575 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458AbaGOKF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:05:57 -0400
Date: Tue, 15 Jul 2014 12:05:37 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH PING] VFS: mount must return EACCES, not EROFS
Message-ID: <20140715100537.GA18099@frolo.macqel>
References: <20140619230924.GO4453@dastard> <1403253562-29248-1-git-send-email-phdm@macqel.be> <20140627082058.GA24986@frolo.macqel> <20140702124651.38b315a8adce63a37fccc60e@linux-foundation.org> <20140703162919.GA16315@frolo.macqel> <20140708140218.ce415094dd073a3ddbd98eeb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708140218.ce415094dd073a3ddbd98eeb@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 02:02:18PM -0700, Andrew Morton wrote:
> On Thu, 3 Jul 2014 18:29:19 +0200 Philippe De Muyter <phdm@macqel.be> wrote:
> 
> > On Wed, Jul 02, 2014 at 12:46:51PM -0700, Andrew Morton wrote:
> > > On Fri, 27 Jun 2014 10:20:58 +0200 Philippe De Muyter <phdm@macqel.be> wrote:
> > > 
> > > > Currently, the initial mount of the root file system by the linux
> > > > kernel fails with a cryptic message instead of being retried with
> > > > the MS_RDONLY flag set,  when the device is read-only and the
> > > > combination of block driver and filesystem driver yields EROFS.
> > > > 
> > > > I do not know if POSIX mandates that mount(2) must fail with EACCES, nor
> > > > if linux aims to strict compliance with POSIX on that point.  Consensus
> > > > amongst the messages that I have read so far seems to show that linux
> > > > kernel hackers feel that EROFS is a more appropriate error code than
> > > > EACCES in that case.
> > > 
> > > Isn't the core problem that "the combination of block driver and
> > > filesystem driver yields EROFS"?  That the fs should instead be
> > > returning EACCESS in this case?
> > 
> > Does POSIX or Linux mandate that it should ?
> > 

For info, SCO Unix documents that mount(2) may fail with EROFS :
and adds "mount is not part of any currently supported standard"

	http://osr507doc.sco.com/en/man/html.S/mount.S.html

Philippe
