Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbaKTNHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:07:40 -0500
Received: from mail.eperm.de ([89.247.134.16]:54692 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaKTNHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:07:38 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Date: Thu, 20 Nov 2014 14:07:33 +0100
Message-ID: <6473728.hPvPq1YETa@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141120080406.GV6390@secunet.com>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <20141120074526.GB29544@gondor.apana.org.au> <20141120080406.GV6390@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 20. November 2014, 09:04:06 schrieb Steffen Klassert:

Hi Steffen,

> On Thu, Nov 20, 2014 at 03:45:26PM +0800, Herbert Xu wrote:
> > On Thu, Nov 20, 2014 at 08:11:42AM +0100, Steffen Klassert wrote:
> > > I think this is not sufficient, crypto_alg_match() will now return the
> > > first algorithm in crypto_alg_list that matches cra_name. We would need
> > > to extend crypto_alg_match() to return the algorithm with the highest
> > > priority in that case.
> > 
> > It doesn't really matter because all implementations must provide
> > exactly the same set of parameters for a given algorithm so it's
> > good enough for what Stephan wants to do.
> 
> Ok, I see.
> 
> > But yes an interface to grab the highest priority algorithm would
> > be useful too so patches are welcome :)
> 
> Should be not too hard to return the highest priority algorithm
> instead of the first match with the existing interface, I'll see
> what I can do.

I think that for the purpose of using crypto-user in an AF_ALG scenario, even 
searching for the highest priporty will not necessarily give you the reference 
to the cipher used in AF_ALG. In the time between AF_ALG initialized a cipher 
and the time crypto-user is called, a new driver could register that may have 
even a higher priority than the one driver currently active for AF_ALG.

Therefore, from my perspective of AF_ALG and considering that all drivers of 
the same name should be identical, I would not suggest add more code to 
resolve the highest priority as I do not see the value of it.

-- 
Ciao
Stephan
