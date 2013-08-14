Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404Ab3HNToT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:44:19 -0400
Received: from imap.thunk.org ([74.207.234.97]:43698 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760381Ab3HNToO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:44:14 -0400
Date: Wed, 14 Aug 2013 15:43:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        david@fromorbit.com, Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Message-ID: <20130814194359.GA22316@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andy Lutomirski <luto@amacapital.net>
References: <520BB9EF.5020308@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BB9EF.5020308@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks dave for doing this comparison.  Is there any chance you can
check whether lockstats shows anything interesting?

> Test case is this:
> 
> 	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c

One interesting thing about the test case.  It looks like the first
time through the while loop, the file will need to be extended (since
it is a new tempfile).  But subsequent times through the list the
blocks for the file will already be allocated.  If the file is
prezero'ed ahead of time, so we're only measuring the cost of the
write page fault, and we take block allocation out of the comparison,
do we see the same scalability curve?


Thanks,

						- Ted
