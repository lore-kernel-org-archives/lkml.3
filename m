Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaKMI6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:58:43 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:49247 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaKMI6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:58:42 -0500
Date: Thu, 13 Nov 2014 16:58:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com
Subject: Re: [PATCH net-next] tun: fix issues of iovec iterators using in
 tun_put_user()
Message-ID: <20141113085838.GA3070@gondor.apana.org.au>
References: <1415868854-4913-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415868854-4913-1-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 04:54:14PM +0800, Jason Wang wrote:
> This patch fixes two issues after using iovec iterators:
> - vlan_offset should be initialized to zero, otherwise unexpected offset
>   will be used in skb_copy_datagram_iter()
> - advance iovec iterator when vnet_hdr_sz is greater than sizeof(gso), this
>   is the case when mergeable rx buffer were enabled for a virt guest.
> 
> Fixes e0b46d0ee9c240c7430a47e9b0365674d4a04522 ("tun: Use iovec iterators")
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Good catch.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
