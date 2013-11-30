Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab3K3BK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 20:10:27 -0500
Received: from imap.thunk.org ([74.207.234.97]:34897 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab3K3BKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 20:10:25 -0500
Date: Fri, 29 Nov 2013 20:10:23 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 7/9] random: forget lock in lockless accounting
Message-ID: <20131130011023.GG3778@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
References: <cover.1384329436.git.price@mit.edu>
 <20131113080828.GU16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113080828.GU16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:08:28AM -0500, Greg Price wrote:
> The only mutable data accessed here is ->entropy_count, but since
> 902c098a3 ("random: use lockless techniques in the interrupt path")
> that member isn't protected by the lock anyway.  Since 10b3a32d2
> ("random: fix accounting race condition") we use cmpxchg to protect
> our accesses to ->entropy_count here.  Drop the use of the lock.

Applied, with a slight change to clarify the commit description:

    The only mutable data accessed here is ->entropy_count, but since
    10b3a32d2 ("random: fix accounting race condition") we use cmpxchg to
    protect our accesses to ->entropy_count here.  Drop the use of the
    lock.

Thanks!

						- Ted
