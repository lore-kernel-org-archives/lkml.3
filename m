Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaKGNVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:21:52 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:56565 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaKGNVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:21:48 -0500
Date: Fri, 7 Nov 2014 21:21:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH 0/4] Replace skb_copy_datagram_const_iovec with iterator
 version
Message-ID: <20141107132135.GA20022@gondor.apana.org.au>
References: <20141106082338.GA29800@gondor.apana.org.au>
 <20141106.122500.4643339498907490.davem@davemloft.net>
 <20141107015944.GB9101@gondor.apana.org.au>
 <20141106.221313.1375322315446025123.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106.221313.1375322315446025123.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave:

This patch series adds the helper skb_copy_datagram_iter, which
is meant to replace both skb_copy_datagram_iovec and its evil
twin skb_copy_datagram_const_iovec.

It then converts tun and macvtap over to the new helper and finally
removes skb_copy_datagram_const_iovec which is only used by tun
and macvtap.

The copy_to_iter return value issue pointed out by Al has now been
fixed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
