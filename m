Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab3HNXHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:07:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:43784 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235Ab3HNXG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:06:59 -0400
Date: Wed, 14 Aug 2013 19:06:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Message-ID: <20130814230648.GD22316@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andy Lutomirski <luto@amacapital.net>
References: <520BB9EF.5020308@linux.intel.com>
 <20130814194359.GA22316@thunk.org>
 <520BED7A.4000903@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BED7A.4000903@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 01:50:02PM -0700, Dave Hansen wrote:
> 
> Would a plain old fallocate() do the trick, or does it actually need
> zeros written to it?

It would be better to write zeros to it, so we aren't measuring the
cost of the unwritten->written conversion.

We could do a different test where at the end of each while loop, we
truncate the file and then do an fallocate, at which point we could be
measuring the scalability of the unwritten->written conversion as well
as the write page fault.  And that might be a useful thing to do at
some point.

But I'd suggest focusing on just the write page fault first, and then
once we're sure we've improved the scalability of that micro-operation
as much as possible, we can expand our scalability testing to include
either writing into fallocated space, or doing extending writes.

Cheers,

						- Ted
