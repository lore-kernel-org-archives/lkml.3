Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaLDP0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:26:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:51863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaLDP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:26:39 -0500
Date: Thu, 4 Dec 2014 15:26:37 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Where exactly will arch_fast_hash be used
Message-ID: <20141204152637.GA32140@casper.infradead.org>
References: <20141204081147.GA19030@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204081147.GA19030@gondor.apana.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/14 at 04:11pm, Herbert Xu wrote:
> Hi:
> 
> While working on rhashtable it came to me that this whole concept
> of arch_fast_hash is flawed.  CRCs are linear functions so it's
> fairly easy for an attacker to identify collisions or at least
> eliminate a large amount of search space (e.g., controlling the
> last bit of the hash result is almost trivial, even when you add
> a random seed).
> 
> So what exactly are we going to use arch_fast_hash for? Presumably
> it's places where security is never goint to be an issue, right?
> 
> Even if security wasn't an issue, straight CRC32 has really poor
> lower-order bit distribution, which makes it a terrible choice for
> a hash table that simply uses the lower-order bits.

As Daniel pointed out, this work originated for the OVS edge use
case where security is of less concern and the rehashing is
sufficient. Identifying collisions is less of interest as the user
space fall back provides a greater surface for an attack.
