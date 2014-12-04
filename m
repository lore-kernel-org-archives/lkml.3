Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaLDIMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:12:13 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35456 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaLDIML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:12:11 -0500
Date: Thu, 4 Dec 2014 16:11:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Graf <tgraf@suug.ch>, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Where exactly will arch_fast_hash be used
Message-ID: <20141204081147.GA19030@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

While working on rhashtable it came to me that this whole concept
of arch_fast_hash is flawed.  CRCs are linear functions so it's
fairly easy for an attacker to identify collisions or at least
eliminate a large amount of search space (e.g., controlling the
last bit of the hash result is almost trivial, even when you add
a random seed).

So what exactly are we going to use arch_fast_hash for? Presumably
it's places where security is never goint to be an issue, right?

Even if security wasn't an issue, straight CRC32 has really poor
lower-order bit distribution, which makes it a terrible choice for
a hash table that simply uses the lower-order bits.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
