Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692Ab3DBXRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:17:05 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58685 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877Ab3DBXRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:17:00 -0400
Date: Tue, 2 Apr 2013 19:16:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130402231613.GA4946@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
	Jiri Slaby <jslaby@suse.cz>
References: <20130402142717.GH32241@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402142717.GH32241@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tried doing some quick timing, and if it is a performance
regression, it's not a recent one --- or I haven't been able to
reproduce what Mel is seeing.  I tried the following commands while
booted into 3.2, 3.8, and 3.9-rc3 kernels:

time git clone ...
rm .git/index ; time git reset

I did this a number of git repo's; including one that was freshly
cloned, and one that had around 3 dozen patches applied via git am (so
there were a bunch of loose objects).  And I tried doing this on an
SSD and a 5400rpm HDD, and I did it with all of the in-memory cache
flushed via "git 3 > /proc/sys/vm/drop_caches".  The worst case was
doing a "time git reset" after deleting the .git/index file after
applying all of Kent Overstreet's recent AIO patches that had been
sent out for review.  It took around 55 seconds, on 3.2, 3.8 and
3.9-rc3.  That is pretty horrible, but for me that's the reason why I
use SSD's.

Mel, how bad is various git commands that you are trying?  Have you
tried using time to get estimates of how long a git clone or other git
operation is taking?

						- Ted
