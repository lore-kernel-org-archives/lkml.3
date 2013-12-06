Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3LFPsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:48:32 -0500
Received: from imap.thunk.org ([74.207.234.97]:37319 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab3LFPsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:48:30 -0500
Date: Thu, 5 Dec 2013 19:31:28 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] random: tighten bound on random_read_wakeup_thresh
Message-ID: <20131206003128.GC9010@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org
References: <cover.1384329436.git.price@mit.edu>
 <20131113080835.GV16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113080835.GV16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:08:35AM -0500, Greg Price wrote:
> We use this value in a few places other than its literal meaning,
> in particular in _xfer_secondary_pool() as a minimum number of
> bits to pull from the input pool at a time into either output
> pool.  It doesn't make sense to pull more bits than the whole size
> of an output pool.
> 
> We could and possibly should separate the quantities "how much
> should the input pool have to have to wake up /dev/random readers"
> and "how much should we transfer from the input to an output pool
> at a time", but nobody is likely to be sad they can't set the first
> quantity to more than 1024 bits, so for now just limit them both.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Greg Price <price@mit.edu>

Thanks, applied.

				- Ted
