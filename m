Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaKTHGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:06:06 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:36317 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaKTHGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:06:03 -0500
Date: Thu, 20 Nov 2014 08:05:52 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Borkmann <dborkman@redhat.com>, <quentin.gouchet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher
 info
Message-ID: <20141120070552.GR6390@secunet.com>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2688209.3bGZus2TD9@tachyon.chronox.de>
 <20141118140822.GB12100@gondor.apana.org.au>
 <16101836.sTaxopCThb@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <16101836.sTaxopCThb@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:03:24AM +0100, Stephan Mueller wrote:
> Am Dienstag, 18. November 2014, 22:08:23 schrieb Herbert Xu:
> 
> Hi Herbert, Steffen,
> 
> > 
> > We already have crypto_user so you should be extending that to
> > cover what's missing.
> 
> After playing a bit with the interface, I think it falls short supporting 
> AF_ALG in the following way:
> 
> crypto_user cannot be applied to the currently active cipher that one has open 
> with AF_ALG. For getting information, one has to call crypto_user with the 
> cra_driver_name of a cipher. (Why is that limitation, btw (see crypto_report 
> and the use of cru_driver_name?)

crypto_report() was intended to provide informations of one implementation
of a algorithm, so it was required to specify this algorithm exactly with
cru_driver_name.

We could extend crypto_report() to provide informations of the algorithm
with the highest priority that matches cra_name.

Or, we also have crypto_dump_report(). This basically provides informations
on all instantiated algorithms, similar to /proc/crypto. We could extend
this in a way that you can provide a cra_name. Then it can dump out the
informations of all algorithms that match cra_name.

