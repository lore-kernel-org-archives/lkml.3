Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaIJN7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:59:38 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:52713
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbaIJN7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:59:36 -0400
Date: Wed, 10 Sep 2014 08:59:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jiri Kosina <jkosina@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
In-Reply-To: <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1409100858470.23359@gentwo.org>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz> <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, Andrew Morton wrote:

> >
> > -	if (unlikely(ZERO_OR_NULL_PTR(objp)))
> > +	if (unlikely(ZERO_OR_NULL_PTR(objp) || IS_ERR(objp)))
> >  		return;
>
> kfree() is quite a hot path to which this will add overhead.  And we
> have (as far as we know) no code which will actually use this at
> present.

We could come up with a macro that does both. Basically if objp < 4086 or
so (signed comparison) then just return.

