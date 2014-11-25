Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaKYJYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:24:21 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:49525 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaKYJYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:24:19 -0500
Date: Tue, 25 Nov 2014 10:24:08 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: crypto: user - crypto_alg_match removal
Message-ID: <20141125092408.GA6390@secunet.com>
References: <3095384.PkgHxCg8eG@tauon>
 <20141124072246.GX6390@secunet.com>
 <1480327.kK94DiIqOk@tachyon.chronox.de>
 <20141125084225.GY6390@secunet.com>
 <20141125090601.GA6244@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141125090601.GA6244@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 05:06:01PM +0800, Herbert Xu wrote:
> On Tue, Nov 25, 2014 at 09:42:25AM +0100, Steffen Klassert wrote:
> >
> > Well, I think there is a small but important difference. If a user
> > requests a driver name that would match an algorithm name (i.e. cbc(aes)
> > instead of cbc(aes-asm)) crypto_alg_lookup() returns the algorithm with
> > the highest priority instead of telling that we don't have a driver with
> > the name cbc(aes).
> 
> Does this matter though? The current user interface is only used to
> query specific driver names which should never be equal to an
> algorithm name.  So doing so already invokes undefined behaviour.
> 

Using an algorithm name as a driver name is a misconfiguration.
We currently, catch these kind of misconfigurations beacuse
we match only driver names with crypto_alg_match().

crypto_alg_lookup() would return the algorithm with the highest
priority in this case and this would indeed lead to undefined
behaviour.
