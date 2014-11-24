Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaKXHW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:22:58 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:54998 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbaKXHW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:22:56 -0500
Date: Mon, 24 Nov 2014 08:22:46 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: crypto: user - crypto_alg_match removal
Message-ID: <20141124072246.GX6390@secunet.com>
References: <3095384.PkgHxCg8eG@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3095384.PkgHxCg8eG@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan.

On Sat, Nov 22, 2014 at 11:25:05PM +0100, Stephan Mueller wrote:
> Hi Steffen, Herbert,
> 
> may I ask for the reasons why crypto_alg_match exists? Doesn't it 
> implement crypto_alg_lookup -- and that not even complete? Is there a 
> particular reason why this exact flag of crypto_alg_match is really 
> needed in the context of crypto_user?
> 
> Unless there is such valid reason, may I ask whether we can remove 
> crypto_alg_match and simply use crypto_alg_lookup in all instances where 
> crypto_alg_match is invoked using the following replacement:
> 
> alg = crypto_alg_lookup(p->cru_name, p->cru_type, p->cru_mask)
> 
> The only problem with this replacement is that p->cru_driver_name is not 
> considered with that. 

With crypto_alg_lookup() we don't know whether the match is based on
the driver or the algorithm name. That's why we have crypto_alg_match(),
here we can ask for a driver or an algorithm match. In some situations it
is important to have an exact match on the crypto driver name. For example
if a user wants to instantiate or delete a certain inplementation of an
algorithm. In this case we need to know whether this exact algorithm
driver is registered in the system.

> Do you think a double invocation of 
> crypto_alg_lookup should be done or that even the user space interface 
> should be changed such that cru_driver_name is removed from it?

Whatever we do, we can't remove cru_driver_name as this is exported
to userspace and tools already use it.

