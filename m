Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaIXTB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:01:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40547 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaIXTB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:01:58 -0400
Date: Wed, 24 Sep 2014 20:01:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fuse: honour max_read and max_write in direct_io mode
Message-ID: <20140924190156.GF7996@ZenIV.linux.org.uk>
References: <20140924150911.GB7441@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924150911.GB7441@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 05:09:11PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The third argument of fuse_get_user_pages() "nbytesp" refers to the number of
> bytes a caller asked to pack into fuse request. This value may be lesser
> than capacity of fuse request or iov_iter.  So fuse_get_user_pages() must
> ensure that *nbytesp won't grow.
> 
> Now, when helper iov_iter_get_pages() performs all hard work of extracting
> pages from iov_iter, it can be done by passing properly calculated
> "maxsize" to the helper.
> 
> The other caller of iov_iter_get_pages() (dio_refill_pages()) doesn't need
> this capability, so pass LONG_MAX as the maxsize argument here.
> 
> Fixes: c9c37e2e6378 ("fuse: switch to iov_iter_get_pages()")
> Reported-by: Werner Baumann <werner.baumann@onlinehome.de>
> Tested-by: Maxim Patlasov <mpatlasov@parallels.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Applied, will be in tonight pull request.
