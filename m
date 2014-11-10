Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaKJOFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:05:24 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33728 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaKJOFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:05:23 -0500
Date: Mon, 10 Nov 2014 22:05:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: crypto: zeroization of sensitive data in af_alg
Message-ID: <20141110140518.GD8578@gondor.apana.org.au>
References: <1979092.odOtqL46qU@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1979092.odOtqL46qU@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 11:33:52PM +0100, Stephan Mueller wrote:
> 
> while working on the AF_ALG interface, I saw no active zeroizations of memory 
> that may hold sensitive data that is maintained outside the kernel crypto API 
> cipher handles. I think the following memory segments fall under that 
> category:

Are you talking about temporary data that we generate as part of
the processing? If so they should be zeroed by the entity that
generates them.
 
> However, I am failing to find the right spot to add a zeroization for the 
> latter one, i.e. the code that handles the pages send in by the user or the 
> pages that are returned by the crypto API. Initially I thought 
> skcipher_pull_sgl is a good spot for the symmetric ciphers as it evicts the 
> used pages out of the scope of the kernel crypto API. I added a 
> clear_page(sg_page(sg+1)) as well as memset(sg_page(sg+1), 0, plen) right 
> before the put_page call. All that I got in return was a BUG() from the memory 
> management layer.

I don't think I understand what exactly you're trying to zero.
Can you give an example?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
