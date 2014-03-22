Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaCVRDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 13:03:36 -0400
Received: from imap.thunk.org ([74.207.234.97]:44753 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaCVRDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 13:03:31 -0400
Date: Sat, 22 Mar 2014 13:03:22 -0400
From: tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-ID: <20140322170322.GA23583@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	reiserfs-devel@vger.kernel.org
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
 <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 01:00:55PM -0700, Andrew Morton wrote:
> 
> The whole point of __GFP_NOFAIL is to centralise this
> wait-for-memory-for-ever operation.  So it is implemented in a common
> (core) place and so that we can easily locate these problematic
> callers.
> 
> is exactly wrong.  Yes, we'd like __GFP_NOFAIL to go away, but it
> cannot go away until buggy callsites such as this one are *fixed*. 
> Removing the __GFP_NOFAIL usage simply hides the buggy code from casual
> searchers.

The change to jbd2 was made in July 2010, back when the "we must
exterminate GFP_NOFAIL at all costs" brigade was in high gear, and the
folks claiming that GFP_FAIL *would* go away, come hell or high water,
was a bit more emphatic.

I'll note that since 2011, there has been precious little movement on
removing the final few callers of GFP_NOFAIL, and we still have a bit
under two dozen of them, including a new one in fs/buffer.c that was
added in 2013.

In any case, __GFP_NOFAIL is in the code comments, so a casual
searcher would find it pretty quickly with a "git grep".

	       	       	      	      	   - Ted
