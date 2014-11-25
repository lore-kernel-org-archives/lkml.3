Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaKYImh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:42:37 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:48547 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaKYImg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:42:36 -0500
Date: Tue, 25 Nov 2014 09:42:25 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: crypto: user - crypto_alg_match removal
Message-ID: <20141125084225.GY6390@secunet.com>
References: <3095384.PkgHxCg8eG@tauon>
 <20141124072246.GX6390@secunet.com>
 <1480327.kK94DiIqOk@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1480327.kK94DiIqOk@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 01:29:10PM +0100, Stephan Mueller wrote:
> Am Montag, 24. November 2014, 08:22:46 schrieb Steffen Klassert:
> 
> > With crypto_alg_lookup() we don't know whether the match is based on
> > the driver or the algorithm name. That's why we have crypto_alg_match(),
> > here we can ask for a driver or an algorithm match. In some situations it
> > is important to have an exact match on the crypto driver name. For example
> > if a user wants to instantiate or delete a certain inplementation of an
> > algorithm. In this case we need to know whether this exact algorithm
> > driver is registered in the system.
> 
> I understand. But going with the logic of the kernel crypto API, if one needs 
> an exact match, you pick the driver name. Otherwise the generic name. 
> crypto_alg_lookup returns the exact algo when you supply a driver name. It 
> returns the algo with the highest prio when you supply a generic name.
> 
> I do not see a difference for the scenarios you describe.

Well, I think there is a small but important difference. If a user
requests a driver name that would match an algorithm name (i.e. cbc(aes)
instead of cbc(aes-asm)) crypto_alg_lookup() returns the algorithm with
the highest priority instead of telling that we don't have a driver with
the name cbc(aes).

