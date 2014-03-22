Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaCVSMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:12:47 -0400
Received: from imap.thunk.org ([74.207.234.97]:44773 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaCVSMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:12:44 -0400
Date: Sat, 22 Mar 2014 14:12:36 -0400
From: tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-ID: <20140322181236.GD23583@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	reiserfs-devel@vger.kernel.org,
	David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
 <20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
 <20140322170322.GA23583@thunk.org>
 <20140322101512.eaeb542b.akpm@linux-foundation.org>
 <20140322172606.GB23583@thunk.org>
 <20140322173207.GC23583@thunk.org>
 <20140322105524.7baec73a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140322105524.7baec73a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 10:55:24AM -0700, Andrew Morton wrote:
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: scripts/checkpatch.pl: __GFP_NOFAIL isn't going away
> 
> Revert 7e4915e78992eb ("checkpatch: add warning of future __GFP_NOFAIL use").
> 
> There are no plans to remove __GFP_NOFAIL.
> 
> __GFP_NOFAIL exists to
> 
> a) centralise the retry-allocation-for-ever operation into the core
>    allocator, which is the appropriate implementation site and
> 
> b) permit us to identify code sites which aren't handling memory
>    exhaustion appropriately.
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

How about also making the following change which inspired the
checkpatch warning?

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0437439..d189872 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -58,9 +58,11 @@ struct vm_area_struct;
  * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
  * _might_ fail.  This depends upon the particular VM implementation.
  *
- * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
- * cannot handle allocation failures.  This modifier is deprecated and no new
- * users should be added.
+ * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the
+ * caller cannot handle allocation failures.  Callers are strongly
+ * encouraged not to use __GFP_NOFAIL unless the alternative is worse
+ * than OOM killing some random process (i.e., corruption or loss of
+ * some innocent user's data, etc).
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely.
  *

