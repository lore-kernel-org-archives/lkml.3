Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaIJO0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:26:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaIJO0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:26:48 -0400
Date: Wed, 10 Sep 2014 16:26:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
In-Reply-To: <20140910140759.GC31903@thunk.org>
Message-ID: <alpine.LNX.2.00.1409101625160.5523@pobox.suse.cz>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz> <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org> <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz> <20140910140759.GC31903@thunk.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Theodore Ts'o wrote:

> I'd much rather depending on better testing and static checkers to fix 
> them, since kfree *is* a hot path.

BTW if we stretch this argument a little bit more, we should also kill the 
ZERO_OR_NULL_PTR() check from kfree() and make it callers responsibility 
to perform the checking only if applicable ... we are currently doing a 
lot of pointless checking in cases where caller would be able to guarantee 
that the pointer is going to be non-NULL.

-- 
Jiri Kosina
SUSE Labs
