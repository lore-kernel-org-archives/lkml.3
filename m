Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaKFI1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:27:14 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:41770 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaKFI1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:27:12 -0500
Date: Thu, 6 Nov 2014 16:27:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: [PATCH 0/4] Replace skb_copy_datagram_const_iovec with iterator
 version
Message-ID: <20141106082704.GB29800@gondor.apana.org.au>
References: <20141104033818.GA11149@gondor.apana.org.au>
 <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
 <20141105.152410.1775725940252546246.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105.152410.1775725940252546246.davem@davemloft.net>
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

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
