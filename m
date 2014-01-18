Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaARML4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 07:11:56 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:39106 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaARMLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 07:11:52 -0500
Date: Sat, 18 Jan 2014 20:11:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH RFC 1/2] crypto: Simple crypto algorithm load balancer
Message-ID: <20140118121145.GA19982@gondor.apana.org.au>
References: <52d9ced0.jqhVV3OvRxex2A9/%tadeusz.struk@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52d9ced0.jqhVV3OvRxex2A9/%tadeusz.struk@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 12:46:08AM +0000, Tadeusz Struk wrote:
> Hi,
> In case of multiple crypto devices implementing the same algorithms
> the arbitration, which one to use is based on the cra_priority.
> Currently the algorithm with the highest priority is always be used.
> In case of two algorithms with the same priority the one added last is used.
> There is no load balancing and on a busy system there can be a situation when
> there more crypto accelerators, but only one is used for all crypto jobs
> and the others sit idle.
> This patch implements a simple load balancing based on the priority
> of an algorithm and its usage refctr. The distribution for 10 algorithms
> and 3000000 tfm_alloc allocations is as follows:

Have you looked at pcrypt and whether it can be extended to handle
this or perhaps something similar to pcrypt can be created?

Hard-coding this into the API seems a bit heavy-handed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
