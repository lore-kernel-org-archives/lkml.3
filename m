Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab3K1OVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:21:36 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:39362 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3K1OVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:21:34 -0500
Date: Thu, 28 Nov 2013 22:21:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] crypto: scatterwalk - Set the chain pointer
 indication bit
Message-ID: <20131128142130.GC32124@gondor.apana.org.au>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
 <20131112174610.19746.91705.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112174610.19746.91705.stgit@tlendack-t1.amdoffice.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:46:10AM -0600, Tom Lendacky wrote:
> The scatterwalk_crypto_chain function invokes the scatterwalk_sg_chain
> function to chain two scatterlists, but the chain pointer indication
> bit is not set.  When the resulting scatterlist is used, for example,
> by sg_nents to count the number of scatterlist entries, a segfault occurs
> because sg_nents does not follow the chain pointer to the chained scatterlist.
> 
> Update scatterwalk_sg_chain to set the chain pointer indication bit as is
> done by the sg_chain function.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.  Thanks!

We should also get rid of the crypto-specific SG helpers since
the generic SG helpers are now available everywhere.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
