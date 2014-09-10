Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaIJN5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:57:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:48276 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaIJN5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:57:02 -0400
Date: Wed, 10 Sep 2014 09:56:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
Message-ID: <20140910135649.GB31903@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Kosina <jkosina@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Dave Jones <davej@redhat.com>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
 <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
 <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
 <20140909221138.2587d864.akpm@linux-foundation.org>
 <20140910063630.GM6549@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910063630.GM6549@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:36:30AM +0300, Dan Carpenter wrote:
> On Tue, Sep 09, 2014 at 10:11:38PM -0700, Andrew Morton wrote:
> > On Wed, 10 Sep 2014 07:05:40 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
> > This is the sort of error which a static checker could find.  I wonder
> > if any of them do so.
> 
> Yes.  Ted asked me to add this to Smatch and that's how we found the
> problems in ext4.  I'll push it out later this week.  It won't find
> every single bug.
> 
> We have fixed the 8 bugs that Smatch found.

The ironic thing is that I asked Dan to add the feature to smatch
because I found two such bugs in ext4, and I suspected there would be
more.  Sure enough, it found four more such bugs, including two in a
recent commit where I had found the first two bugs --- and I had
missed the other two even though I was specifically looking for such
instances.  Oops.  :-)

Maybe we can add a debugging config option?  I think having static
checkers plus some kmalloc failure testing should be sufficient to
prevent these sorts of problem from showing up.

It would seem to me that this is the sort of thing that a static
checker should find reliably; Coverity has found things that were more
complex than what this should require, I think.  I don't know if they
would be willing to add something this kernel-specific, though.  (I've
added Dave Jones to the thread since he's been working a lot with
Coverity; Dave, what do you think?)

      	 	    		       - Ted
