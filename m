Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaKDOw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:52:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40900 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKDOwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:52:25 -0500
Date: Tue, 4 Nov 2014 14:52:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141104145222.GF7996@ZenIV.linux.org.uk>
References: <20141104033818.GA11149@gondor.apana.org.au>
 <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
 <20141104143200.GC7996@ZenIV.linux.org.uk>
 <20141104143536.GD7996@ZenIV.linux.org.uk>
 <20141104144416.GB14743@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104144416.GB14743@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:44:16PM +0800, Herbert Xu wrote:
> On Tue, Nov 04, 2014 at 02:35:36PM +0000, Al Viro wrote:
> > On Tue, Nov 04, 2014 at 02:32:00PM +0000, Al Viro wrote:
> >
> > > Too noisy, IMO.  How about skb_copy_datagram_msg() first?  The fewer
> > > places have to even think of iovec or iov_iter, the better...
> > 
> > PS: "too noisy" is about turning every callsite of skb_copy_datagram_iovec
> > into that of skb_copy_datagram_iter; the helper itself is just fine.
> 
> Hmm if that is your concern then I don't see how skb_copy_datagram_msg
> changes things as you'd still have to convert every existing caller
> of skb_copy_datagram_iovec.  Colour me confused.

Fewer places having to even think of iovec/iov_iter...
