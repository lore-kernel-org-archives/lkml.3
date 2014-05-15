Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaEONqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:46:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbaEONqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:46:13 -0400
Date: Thu, 15 May 2014 15:46:10 +0200
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Mateusz Guzik <mguzik@redhat.com>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140515134610.GB660@quack.suse.cz>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
 <20140514215457.GC5421@dastard>
 <20140515094236.GE10637@mguzik.redhat.com>
 <20140515100157.GB27289@quack.suse.cz>
 <20140515124725.GA8194@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515124725.GA8194@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-05-14 08:47:25, Ted Tso wrote:
> On Thu, May 15, 2014 at 12:01:57PM +0200, Jan Kara wrote:
> >   I was tracking down a couple of times what the hell is freezing the
> > filesystem (and not unfreezing it) and I agree with Mateusz it would be
> > nice if we could tell after the fact who froze the fs. Maybe we could store
> > that information in superblock and dump it during emergency thaw?
> 
> Saving it in the superblock would require changing a bunch of file
> systems.  What if we store this information in memory, and print it
> out under certain conditions (i.e., after a soft lockup detection, or
> upon request of some magic sysrq request)?
  By 'superblock' I meant 'struct super_block' ;) So we are in agreement I
believe.

> Or we could create a tunable threshold and print a message after a
> file system has been frozen more than a particular specified duration,
> with that duration set conservatively to something like 60 or 120
> seconds by default.
  I was thinking about this as well but all these "warn after X seconds"
warnings tend to have quite a few false positives in practice so dumping
this in emergency-thaw sysrq handler or exposing the information somewhere
in proc (e.g. mountinfo) would look like a better option to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
