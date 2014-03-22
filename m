Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaCVR0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 13:26:17 -0400
Received: from imap.thunk.org ([74.207.234.97]:44757 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaCVR0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 13:26:14 -0400
Date: Sat, 22 Mar 2014 13:26:06 -0400
From: tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-ID: <20140322172606.GB23583@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	reiserfs-devel@vger.kernel.org
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
 <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
 <20140322170322.GA23583@thunk.org>
 <20140322101512.eaeb542b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140322101512.eaeb542b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 10:15:12AM -0700, Andrew Morton wrote:
> > I'll note that since 2011, there has been precious little movement on
> > removing the final few callers of GFP_NOFAIL, and we still have a bit
> > under two dozen of them, including a new one in fs/buffer.c that was
> > added in 2013.
> 
> Well.  Converting an existing retry-for-ever caller to GFP_NOFAIL is
> good.  Adding new retry-for-ever code is not good.

Actually, it wasn't converting an existing loop; it was adding a new
GFP_NOFAIL to fix a reclaim livelock (commit 84235de394d9775bf).

I agree that in ideal world, we'd get rid of all of these.  But
sometimes, the cure can be worse than the disesae, and so the whole
"all callers of GFP_NOFAIL are MUST FIX BUGGGY and the maintainers
should be shamed into fixing it" attitude is one that I find a bit odd
myself.

	      	    	    	     	     - Ted
