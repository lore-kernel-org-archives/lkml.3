Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaIJGv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:51:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51928 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaIJGv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:51:57 -0400
Date: Wed, 10 Sep 2014 09:51:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
Message-ID: <20140910065129.GN6549@mwanda>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
 <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
 <113623.1410326115@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113623.1410326115@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:15:15AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 09 Sep 2014 16:21:14 -0700, Andrew Morton said:
> > On Tue, 9 Sep 2014 23:25:28 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
> > kfree() is quite a hot path to which this will add overhead.  And we
> > have (as far as we know) no code which will actually use this at
> > present.
> 
> We already do a check for ZERO_SIZE_PTR, and given that dereferencing *that* is
> instant death for the kernel, and we see it very rarely, I'm going to guess
> that IS_ERR(ptr) *has* to be true more often than ZERO_SIZE_PTR, and thus even
> more advantageous to short-circuit.

ZERO_SIZE_PTR is sort of common.

ZERO_SIZE_PTR is an mm abstraction and kfree() and ksize() are basically
the only places where we need to test for it.  Also friends of kfree()
like jbd2_journal_free_transaction().

regards,
dan carpenter
