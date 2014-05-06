Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaEFVLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:11:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33857 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbaEFVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:11:29 -0400
Date: Tue, 6 May 2014 23:11:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Milos Vyletel <milos.vyletel@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>,
        linux-coverity@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/sha1: fix coverity CID 1195603
Message-ID: <20140506211128.GA13218@amd.pavel.ucw.cz>
References: <1398885474-21388-1-git-send-email-milos.vyletel@gmail.com>
 <20140506082846.GB20931@xo-6d-61-c0.localdomain>
 <CAAFXRd3UPRU7AgZCGbxo_YW_PGuO-FPvB4VC5zKb+LuqGxFxkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFXRd3UPRU7AgZCGbxo_YW_PGuO-FPvB4VC5zKb+LuqGxFxkQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Most likely yes but I wanted to keep sha1_ssse3_mod_init consistent
> with sha256_ssse3_mod_init/sha512_ssse3_mod_init functions.


> > > Reported-by: <scan-admin@coverity.com>
> > > Signed-off-by: Milos Vyletel <milos.vyletel@gmail.com>
> > > ---
> > >  arch/x86/crypto/sha1_ssse3_glue.c | 22 ++++++++++++----------
> > >  1 file changed, 12 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/arch/x86/crypto/sha1_ssse3_glue.c
> > b/arch/x86/crypto/sha1_ssse3_glue.c
> > > index 74d16ef..5352196 100644
> > > --- a/arch/x86/crypto/sha1_ssse3_glue.c
> > > +++ b/arch/x86/crypto/sha1_ssse3_glue.c
> > > @@ -235,31 +235,33 @@ static bool __init avx2_usable(void)
> > >
> > >  static int __init sha1_ssse3_mod_init(void)
> > >  {
> > > -     char *algo_name;
> > > -
> >
> > Would simple "algo_name = NULL" be enough to fix this?

Dunno. I'd say that single-line change that is obviously right is
preferable to rewrite inspired by some other function.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
