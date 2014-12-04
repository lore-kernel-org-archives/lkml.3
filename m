Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaLDQLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:11:19 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33097 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbaLDQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:11:16 -0500
Date: Fri, 5 Dec 2014 00:10:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Where exactly will arch_fast_hash be used
Message-ID: <20141204161058.GA22431@gondor.apana.org.au>
References: <20141204081147.GA19030@gondor.apana.org.au>
 <20141204152637.GA32140@casper.infradead.org>
 <20141204152929.GA22075@gondor.apana.org.au>
 <20141204153938.GC32140@casper.infradead.org>
 <54808123.8000704@redhat.com>
 <20141204154708.GA22185@gondor.apana.org.au>
 <063D6719AE5E284EB5DD2968C1650D6D1CA0284A@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CA0284A@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:56:30PM +0000, David Laight wrote:
> 
> "This CRC algorithm used by this hash is 'linear', ie hash(a xor b) ==
> hash(a) xor hash(b). This means that it is relatively easy for a remote
> attacker to generate multiple items with the same hash."

The attacker could be local too, e.g., opening a netlink socket
can be done by any user and gets hashed in net/netlink/af_netlink.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
