Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaKTEO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 23:14:58 -0500
Received: from mail.eperm.de ([89.247.134.16]:54672 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbaKTEO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 23:14:56 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher info
Date: Thu, 20 Nov 2014 05:14:49 +0100
Message-ID: <1886827.KUDIsNtfuk@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141120040748.GB28420@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <16101836.sTaxopCThb@tachyon.chronox.de> <20141120040748.GB28420@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 20. November 2014, 12:07:48 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 20, 2014 at 05:03:24AM +0100, Stephan Mueller wrote:
> > crypto_user cannot be applied to the currently active cipher that one has
> > open with AF_ALG. For getting information, one has to call crypto_user
> > with the cra_driver_name of a cipher. (Why is that limitation, btw (see
> > crypto_report and the use of cru_driver_name?)
> 
> It doesn't matter because every implementation must supply exactly
> the same parameters as the reference implementation or it's buggy.
> IOW block size, IV size, supported key sizes etc. are intrinsic
> properties of the algorithm and not the implementation.
> 
I totally understand that. But you cannot supply a cra_name to crypto-user to 
get infos of that cipher as it is currently written. You have to use a 
cra_driver_name.

So, when I use a cra_name with AF_ALG, where would I get the cra_driver_name 
from to query the details from crypto_user?

Or we have to patch crypto_user to allow the use of cra_name -- which is 
currently explicitly disabled.

> Cheers,


-- 
Ciao
Stephan
