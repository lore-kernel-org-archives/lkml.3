Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaKTIl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:41:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58354 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184AbaKTIl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:41:58 -0500
Date: Thu, 20 Nov 2014 08:41:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] macvtap: advance iov iterator when needed in
 macvtap_put_user()
Message-ID: <20141120084152.GL7996@ZenIV.linux.org.uk>
References: <1416472265-10151-1-git-send-email-jasowang@redhat.com>
 <20141120083426.GA30001@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120083426.GA30001@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:34:26PM +0800, Herbert Xu wrote:
> On Thu, Nov 20, 2014 at 04:31:05PM +0800, Jason Wang wrote:
> > When mergeable buffer is used, vnet_hdr_sz is greater than sizeof struct
> > virtio_net_hdr. So we need advance the iov iterators in this case.
> > 
> > Fixes 6c36d2e26cda1ad3e2c4b90dd843825fc62fe5b4 ("macvtap: Use iovec iterators")
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

I'm not sure it's a good behaviour, actually - should we just leave an
unmodified gap in userland buffer there, with whatever garbage it might
have contained?

I do realize that this is what we used to do, but it might end up a source
of hard to debug userland bugs...  Perhaps that iov_iter_advance(iter, size)
would better be replaced with iov_iter_zero(size, iter)?
