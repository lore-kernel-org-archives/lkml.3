Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaIQPn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:43:57 -0400
Received: from imap.thunk.org ([74.207.234.97]:33902 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaIQPnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:43:55 -0400
Date: Wed, 17 Sep 2014 11:43:27 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/7] Define new syscalls readv2,preadv2,writev2,pwritev2
Message-ID: <20140917154327.GA12190@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	Mel Gorman <mgorman@suse.de>,
	Volker Lendecke <Volker.Lendecke@sernet.de>,
	Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>
References: <cover.1410810247.git.milosz@adfin.com>
 <057d758976db2fcce58e394abaa0d55e48cdeec1.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <057d758976db2fcce58e394abaa0d55e48cdeec1.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 04:20:37PM -0400, Milosz Tanski wrote:
> New syscalls with an extra flag argument. For now all flags except for 0 are
> not supported.

This may fall in the category of bike-shedding, and so I apologize in
advance, but I wonder if we really need readv2 and writev2 as new
syscalls.  What if we just added preadv2 and pwritev2, and implemented
readv2 and writev2 as libc wrappers where which had the vector
allocated as an automatic stack variable?  Is the extra user memory
access really going to be that noticeable?

Cheers,

	       	      	       	       - Ted
