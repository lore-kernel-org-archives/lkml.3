Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaIJP2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:28:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaIJP2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:28:15 -0400
Date: Wed, 10 Sep 2014 17:28:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: "Theodore Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
In-Reply-To: <20140910152104.GS6549@mwanda>
Message-ID: <alpine.LNX.2.00.1409101725340.5523@pobox.suse.cz>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz> <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org> <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz> <20140910140759.GC31903@thunk.org> <alpine.LNX.2.00.1409101625160.5523@pobox.suse.cz>
 <20140910152104.GS6549@mwanda>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Dan Carpenter wrote:

> > BTW if we stretch this argument a little bit more, we should also kill the 
> > ZERO_OR_NULL_PTR() check from kfree() and make it callers responsibility 
> > to perform the checking only if applicable ... we are currently doing a 
> > lot of pointless checking in cases where caller would be able to guarantee 
> > that the pointer is going to be non-NULL.
> 
> What you're saying is that we should remove the ZERO_SIZE_PTR
> completely.  ZERO_SIZE_PTR is a very useful idiom and also it's too late
> to remove it because everything depends on it.

I was just argumenting that if we care about single additional test in 
this path, the ZERO_OR_NULL_PTR() should have never been added at the 
first place, and the responsibility for checking should have been kept at 
callers.

Too late for this now, yes.

-- 
Jiri Kosina
SUSE Labs
