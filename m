Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab3BSMZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:25:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17509 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3BSMZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:25:35 -0500
Date: Tue, 19 Feb 2013 15:25:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH 1/2] staging/sep: Fix smatch false positive about
 potential NULL dereference in sep_main.c
Message-ID: <20130219122508.GA9138@mwanda>
References: <1361275648-6259-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361275648-6259-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 01:07:27PM +0100, Peter Huewe wrote:
> Smatch complains about a potential NULL pointer dereference:
> 
> sep_main.c:2312 sep_construct_dma_tables_from_lli() error: potential
> NULL dereference 'info_out_entry_ptr'.
> 
> info_out_entry_ptr is initialized with NULL and if info_in_entry_ptr is
> not NULL it gets derefenced.
> However info_out_entry_ptr is only NULL in the first iteration of the
> while loop and in this case info_in_entry_ptr is also NULL (as indicated
> by the comment /* If info entry is null - this is the first table built */
> -> this is a false positive.
> 
> Nevertheless we add a check for info_out_entry_ptr to silence this
> warning and make it more robust in regard to code changes.
> 

Smatch doesn't handle loops very well.  Of course, all along I've
wanted to fix this, but it's a bit complicated so it could be
another year or two before it actually happens.

Generally, as a philosophy, I always say never to change the code
for false positives.  It should be Smatch which changes.

Also the other thing is that with Smatch I deliberately allow more
false positives than GCC does.  It's a trade off between being
ambitious in looking for bugs and being annoying to users.

When Smatch looks at this code it sees the else side as impossible
to reach.  Perhaps I should add a hack in that if the code is in an
impossible to reach place then don't print a warning...  It would
be better to just fix loop handling...  I'm not sure.

regards,
dan carpenter

