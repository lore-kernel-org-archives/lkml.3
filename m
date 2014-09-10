Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaIJTkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:40:21 -0400
Received: from imap.thunk.org ([74.207.234.97]:49180 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaIJTkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:40:19 -0400
Date: Wed, 10 Sep 2014 15:40:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
Message-ID: <20140910194010.GE31903@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
 <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
 <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
 <20140910140759.GC31903@thunk.org>
 <alpine.LNX.2.00.1409101625160.5523@pobox.suse.cz>
 <20140910152104.GS6549@mwanda>
 <alpine.LNX.2.00.1409101725340.5523@pobox.suse.cz>
 <20140910155356.GT6549@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910155356.GT6549@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 06:53:56PM +0300, Dan Carpenter wrote:
> On Wed, Sep 10, 2014 at 05:28:11PM +0200, Jiri Kosina wrote:
> > 
> > Too late for this now, yes.
> 
> We could still introduce a __kfree_fast_path() which doesn't have
> checking.

Well, there certainly is precedence for that sort of thing.  There is
a bunch of code which uses __brelse(bh) instead of brelse(bh) when the
caller is sure that bh is a valid non-NULL pointer.

						- Ted
