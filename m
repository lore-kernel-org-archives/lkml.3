Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaCJWHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaCJWHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:07:50 -0400
Date: Tue, 11 Mar 2014 00:07:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, jbenc@redhat.com,
        David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Simon Horman <horms@verge.net.au>,
        Paul Durrant <Paul.Durrant@citrix.com>, Thomas Graf <tgraf@suug.ch>,
        Miklos Szeredi <mszeredi@suse.cz>,
        =?us-ascii?B?PT9VVEYtOD9xP1BldGVyPTIwUGFuPTI4PUU2PUJEPTk4PUU1PThEPUFC?=
	 =?us-ascii?B?PUU1PUI5PUIzPTI5Pz0=?= <panweiping3@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] skbuff: skb_segment: orphan frags before copying
Message-ID: <20140310220717.GA7150@redhat.com>
References: <1394468807-25980-1-git-send-email-mst@redhat.com>
 <1394468807-25980-6-git-send-email-mst@redhat.com>
 <20140310213404.GB15352@gondor.apana.org.au>
 <20140310215236.GA7052@redhat.com>
 <20140310215640.GA15684@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310215640.GA15684@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 05:56:40AM +0800, Herbert Xu wrote:
> On Mon, Mar 10, 2014 at 11:52:36PM +0200, Michael S. Tsirkin wrote:
> >
> > The cover letter has more detail:
> 
> For some reason I didn't receive this cover letter.
> > 	skb_segment ... moves frags
> > 	between skbs without orphaning them.
> > 	This causes userspace to assume it's safe to
> > 	reuse the buffer, and receiver gets corrupted data.
> > 	This further might leak information from the
> > 	transmitter on the wire.
> > 
> > if still unclear, pls let me know.
> 
> Why can't we deal with this by simply postponing the copy until
> later?
> 
> Thanks,

Once one skb completes the callback is invoked and userspace
reuses this buffer for something else.
At that point it's too late to do the copy.


> IOW if we pass along SKBTX_SHARED_FRAG will it work?

I don't see how would SKBTX_SHARED_FRAG help with this at all.
That only works for pages gifted to kernel by e.g. vmsplice
that aren't reused by userspace.


> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
