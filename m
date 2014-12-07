Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaLGMwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 07:52:11 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33372 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaLGMwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 07:52:09 -0500
Date: Sun, 7 Dec 2014 20:51:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: George Spelvin <linux@horizon.com>
Cc: dborkman@redhat.com, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tgraf@suug.ch,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Where exactly will arch_fast_hash be used
Message-ID: <20141207125157.GA9745@gondor.apana.org.au>
References: <20141207092828.GA8623@gondor.apana.org.au>
 <20141207100252.6707.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141207100252.6707.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 05:02:52AM -0500, George Spelvin wrote:
>
> How does this implicate the low bits specifically?

If you can easily deduce the pre-images that make the last bit
of the hash even or odd, then you've just cut your search space
for collisions by half.  The real killer is that you can do this
without knowing what the secret is.

Our entire scheme is dependent on using the secret to defeat
would-be attackers.  If CRC does not make effective use of the
secret, then we're essentially naked against attackers.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
