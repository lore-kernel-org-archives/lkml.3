Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaKCAVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 19:21:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35385 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaKCAVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 19:21:42 -0500
Date: Mon, 3 Nov 2014 00:21:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: fs: Use non-const iov in aio_read/aio_write
Message-ID: <20141103002139.GW7996@ZenIV.linux.org.uk>
References: <20141102230552.GA26095@gondor.apana.org.au>
 <20141103001634.GV7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103001634.GV7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 12:16:34AM +0000, Al Viro wrote:

> NAK with extreme prejudice.  The right way to deal with that is
> to convert the socket side of things to iov_iter.  And give it a
> consistent behaviour, while we are at it (some protocols do advance
> the damn thing, so do not).  There are _very_ good reasons to have those
> iovecs unchanged - if you look at the callers on the socket side, you'll
> see a bunch that has to _copy_ iovec just to avoid it being buggered.
> And you get rather suboptimal behaviour in memcpy_fromiovec() and friends,
> exactly because you have to skip through the emptied elements.
> 
> IOW, no way in hell.

PS: I do have the beginning of that stuff sitting in the local queue since
April; see http://marc.info/?l=linux-xfs&m=139179304710494&w=2 for the
beginning of the story.
