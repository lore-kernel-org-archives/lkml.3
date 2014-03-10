Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbaCJVea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:34:30 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:52166 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaCJVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:34:29 -0400
Date: Tue, 11 Mar 2014 05:34:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20140310213404.GB15352@gondor.apana.org.au>
References: <1394468807-25980-1-git-send-email-mst@redhat.com>
 <1394468807-25980-6-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394468807-25980-6-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 06:29:36PM +0200, Michael S. Tsirkin wrote:
> skb_segment copies frags around, so we need
> to copy them carefully to avoid accessing
> user memory after reporting completion to userspace
> through a callback.
> 
> skb_segment doesn't normally happen on datapath:
> TSO needs to be disabled - so disabling zero copy
> in this case does not look like a big deal.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Why do we need this patch at all? Contrary to what you said,
this path is definitely performance-critical since the basis
of being able to enable GSO by default is that it causes no
regressions in non-TSO cases.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
