Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbaKTIx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:53:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbaKTIxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:53:46 -0500
Message-ID: <546DAC0F.90206@redhat.com>
Date: Thu, 20 Nov 2014 16:53:35 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] macvtap: advance iov iterator when needed in
 macvtap_put_user()
References: <1416472265-10151-1-git-send-email-jasowang@redhat.com> <20141120083426.GA30001@gondor.apana.org.au> <20141120084152.GL7996@ZenIV.linux.org.uk>
In-Reply-To: <20141120084152.GL7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 04:41 PM, Al Viro wrote:
> On Thu, Nov 20, 2014 at 04:34:26PM +0800, Herbert Xu wrote:
>> On Thu, Nov 20, 2014 at 04:31:05PM +0800, Jason Wang wrote:
>>> When mergeable buffer is used, vnet_hdr_sz is greater than sizeof struct
>>> virtio_net_hdr. So we need advance the iov iterators in this case.
>>>
>>> Fixes 6c36d2e26cda1ad3e2c4b90dd843825fc62fe5b4 ("macvtap: Use iovec iterators")
>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> I'm not sure it's a good behaviour, actually - should we just leave an
> unmodified gap in userland buffer there, with whatever garbage it might
> have contained?

Anyway it's the users(qemu or vhost_net) responsibility to fill the gap
here.
> I do realize that this is what we used to do, but it might end up a source
> of hard to debug userland bugs...  Perhaps that iov_iter_advance(iter, size)
> would better be replaced with iov_iter_zero(size, iter)?

Not sure, macvtap or tun behave like this in the past. It's easy to dump
the header in guest for debugging. Zero the gap probably only help the
case that the gap was forgot to be filled which looks rare.
