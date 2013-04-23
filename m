Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3DWPvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:51:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43913 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab3DWPvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:51:06 -0400
Date: Tue, 23 Apr 2013 11:50:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130423155019.GH31170@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mel Gorman <mgorman@suse.de>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>
References: <20130402150651.GB31577@thunk.org>
 <20130410105608.GC1910@suse.de>
 <20130410131245.GC4862@thunk.org>
 <20130411170402.GB11656@suse.de>
 <20130411183512.GA12298@thunk.org>
 <20130411213335.GE9379@quack.suse.cz>
 <20130412025708.GB7445@thunk.org>
 <20130412094731.GI11656@suse.de>
 <20130421000522.GA5054@thunk.org>
 <20130423153305.GB2108@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423153305.GB2108@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 04:33:05PM +0100, Mel Gorman wrote:
> That's a pretty big drop but it gets bad again for the second worst stall --
> wait_on_page_bit as a result of generic_file_buffered_write.
> 
> Vanilla kernel  1336064 ms stalled with 109 events
> Patched kernel  2338781 ms stalled with 164 events

Do you have the stack trace for this stall?  I'm wondering if this is
caused by the waiting for stable pages in write_begin() , or something
else.

If it is blocking caused by stable page writeback that's interesting,
since it would imply that something in your workload is trying to
write to a page that has already been modified (i.e., appending to a
log file, or updating a database file).  Does that make sense given
what your workload might be running?

					- Ted
