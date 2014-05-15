Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaEOMrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:47:36 -0400
Received: from imap.thunk.org ([74.207.234.97]:41684 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaEOMre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:47:34 -0400
Date: Thu, 15 May 2014 08:47:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mguzik@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140515124725.GA8194@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@redhat.com>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Eric Sandeen <esandeen@redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
 <20140514215457.GC5421@dastard>
 <20140515094236.GE10637@mguzik.redhat.com>
 <20140515100157.GB27289@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515100157.GB27289@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 12:01:57PM +0200, Jan Kara wrote:
>   I was tracking down a couple of times what the hell is freezing the
> filesystem (and not unfreezing it) and I agree with Mateusz it would be
> nice if we could tell after the fact who froze the fs. Maybe we could store
> that information in superblock and dump it during emergency thaw?

Saving it in the superblock would require changing a bunch of file
systems.  What if we store this information in memory, and print it
out under certain conditions (i.e., after a soft lockup detection, or
upon request of some magic sysrq request)?

Or we could create a tunable threshold and print a message after a
file system has been frozen more than a particular specified duration,
with that duration set conservatively to something like 60 or 120
seconds by default.

						- Ted
