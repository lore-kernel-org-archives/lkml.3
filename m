Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaE0Ra6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:30:58 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:60742 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaE0Raz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:30:55 -0400
Date: Wed, 28 May 2014 01:30:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Seth Jennings <sjennings@variantweb.net>
Subject: Re: [PATCH] crypto: lzo: try kmalloc() before vmalloc()
Message-ID: <20140527173050.GA18214@gondor.apana.org.au>
References: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:28:55AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> zswap allocates one LZO context per online cpu.
> 
> Using vmalloc() for small (16KB) memory areas has drawback of slowing
> down /proc/vmallocinfo and /proc/meminfo reads, TLB pressure and poor
> NUMA locality, as default NUMA policy at boot time is to interleave
> pages :
> 
> edumazet:~# grep lzo /proc/vmallocinfo | head -4
> 0xffffc90006062000-0xffffc90006067000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
> 0xffffc90006067000-0xffffc9000606c000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
> 0xffffc9000606c000-0xffffc90006071000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
> 0xffffc90006071000-0xffffc90006076000   20480 lzo_init+0x1b/0x30 pages=4 vmalloc N0=2 N1=2
> 
> This patch tries a regular kmalloc() and fallback to vmalloc in case
> memory is too fragmented.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Looks good to me.  This would seem like something that could be
generalised to other vmalloc users, no?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
