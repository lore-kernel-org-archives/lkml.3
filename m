Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaKDOcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:32:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40856 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaKDOcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:32:05 -0500
Date: Tue, 4 Nov 2014 14:32:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141104143200.GC7996@ZenIV.linux.org.uk>
References: <20141104033818.GA11149@gondor.apana.org.au>
 <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 04:31:34PM +0800, Herbert Xu wrote:
> This patch adds skb_copy_datagram_iter, which is identical to
> skb_copy_datagram_iovec except that it operates on iov_iter
> instead of iovec.
> 
> Eventually all users of skb_copy_datagram_iovec should switch
> over to iov_iter and then we can remove skb_copy_datagram_iovec.

Too noisy, IMO.  How about skb_copy_datagram_msg() first?  The fewer
places have to even think of iovec or iov_iter, the better...
