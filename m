Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaLWI1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:27:47 -0500
Received: from mail.eperm.de ([89.247.134.16]:51001 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaLWI1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:27:45 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 5/8] crypto: AF_ALG: add user space interface for RNG
Date: Tue, 23 Dec 2014 09:27:40 +0100
Message-ID: <1708286.gWpYI6yUk0@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141222112730.GB19532@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de> <3380968.kTQNpvjKFa@tachyon.chronox.de> <20141222112730.GB19532@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. Dezember 2014, 22:27:30 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Dec 07, 2014 at 11:23:48PM +0100, Stephan Mueller wrote:
> > Allow user space to seed / reset the RNG via a setsockopt.
> > 
> > This patch reuses alg_setkey to copy data into the kernel. The
> > alg_setkey is now used for two mechanisms: setkey and seeding.
> > The function is extended by the providing the function pointer
> > to the function handling the copied data.
> > 
> > As the alg_setkey is now usable for more than just setkey, it is renamed
> > to alg_setop.
> 
> Just call it setkey, there is no harm in treating the seed as a key
> is there?
> 
> In fact we should have done this from the very start.
> crypto_rng_reset should be renamed crypto_rng_setkey.

Ok, that means I will drop this patch entirely and wire up the reseeding 
function in algif_rng.c with setkey.
> 
> Cheers,


-- 
Ciao
Stephan
