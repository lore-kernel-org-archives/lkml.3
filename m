Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaKDOzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:55:47 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55935 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaKDOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:55:46 -0500
Date: Tue, 4 Nov 2014 22:55:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141104145538.GA14944@gondor.apana.org.au>
References: <20141104033818.GA11149@gondor.apana.org.au>
 <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
 <20141104143200.GC7996@ZenIV.linux.org.uk>
 <20141104143536.GD7996@ZenIV.linux.org.uk>
 <20141104144416.GB14743@gondor.apana.org.au>
 <20141104145222.GF7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104145222.GF7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 02:52:22PM +0000, Al Viro wrote:
>
> > Hmm if that is your concern then I don't see how skb_copy_datagram_msg
> > changes things as you'd still have to convert every existing caller
> > of skb_copy_datagram_iovec.  Colour me confused.
> 
> Fewer places having to even think of iovec/iov_iter...

Well it's the difference between

	skb_copy_datagram_iter(..., &kmsghdr->iov_iter, ...)

and

	skb_copy_datagram_msg(..., kmsghdr, ...)

Heck we could even make skb_copy_datagram_msg an inline wrapper
around skb_copy_datagram_iter if you like.

Anyway, the point is that not everything comes with a kmsghdr.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
