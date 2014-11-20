Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaKTIET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:04:19 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:37804 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaKTIER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:04:17 -0500
Date: Thu, 20 Nov 2014 09:04:06 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephan Mueller <smueller@chronox.de>,
        Daniel Borkmann <dborkman@redhat.com>, <quentin.gouchet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Message-ID: <20141120080406.GV6390@secunet.com>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <1886827.KUDIsNtfuk@tachyon.chronox.de>
 <20141120041824.GA28612@gondor.apana.org.au>
 <3538055.XH2t7HNEVj@tachyon.chronox.de>
 <20141120044650.GA28691@gondor.apana.org.au>
 <20141120071141.GS6390@secunet.com>
 <20141120074526.GB29544@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141120074526.GB29544@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.182.7.102]
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 03:45:26PM +0800, Herbert Xu wrote:
> On Thu, Nov 20, 2014 at 08:11:42AM +0100, Steffen Klassert wrote:
> >
> > I think this is not sufficient, crypto_alg_match() will now return the first
> > algorithm in crypto_alg_list that matches cra_name. We would need to extend
> > crypto_alg_match() to return the algorithm with the highest priority in that
> > case.
> 
> It doesn't really matter because all implementations must provide
> exactly the same set of parameters for a given algorithm so it's
> good enough for what Stephan wants to do.

Ok, I see.

> But yes an interface to grab the highest priority algorithm would
> be useful too so patches are welcome :)

Should be not too hard to return the highest priority algorithm
instead of the first match with the existing interface, I'll see
what I can do.
