Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3KMDcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:32:18 -0500
Received: from imap.thunk.org ([74.207.234.97]:57603 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab3KMDcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:32:12 -0500
Date: Tue, 12 Nov 2013 22:32:05 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
Message-ID: <20131113033205.GA9214@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
References: <cover.1383868558.git.price@mit.edu>
 <20131112042444.GC30281@thunk.org>
 <20131112224009.GX8043@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112224009.GX8043@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 05:40:09PM -0500, Greg Price wrote:
> 
> Beyond these easy cleanups, I have a couple of patches queued up (just
> written yesterday, not quite finished) to make /dev/urandom block at
> boot until it has enough entropy, as the "Mining your P's and Q's"
> paper recommended and people have occasionally discussed since then.
> Those patches were definitely for after 3.13 anyway, and I'll send
> them when they're ready.  I see some notifications and warnings in
> this direction in the random.git tree, which is great.

One of the things I've been thinking about with respect to making
/dev/urandom block is being able to configure (via a module parameter
which could be specified on the boot command line) which allows us to
set a limit for how long /dev/urandom will block after which we log a
high priority message that there was an attempt to read from
/dev/urandom which couldn't be satisified, and then allowing the
/dev/urandom read to succed.

The basic idea is that we don't want to break systems, but we do want
to gently coerce people to do the right thing.  Otherwise, I'm worried
that distros, or embedded/mobile/consume electronics engineers would
just patch out the check.  If we make the default be something like
"block for 5 minutes", and then log a message, we won't completely
break a user who is trying to login to a VM, but it will be obvious,
both from the delay and from the kern.crit log message, that there is
a potential problem here that a system administrator needs to worry
about.

						- Ted


