Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaKOC3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 21:29:21 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35788 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaKOC3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 21:29:19 -0500
Date: Sat, 15 Nov 2014 10:28:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Ming Liu <ming.liu@windriver.com>
Subject: Re: simd: Allow simd use in kernel threads with softirqs disabled
Message-ID: <20141115022832.GA18950@gondor.apana.org.au>
References: <20141114154315.GA15771@gondor.apana.org.au>
 <CAKv+Gu8gB-WwM81iDuFsd+Nh8tR3D1H53pAf5w1p1botE8uWHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8gB-WwM81iDuFsd+Nh8tR3D1H53pAf5w1p1botE8uWHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 05:17:05PM +0100, Ard Biesheuvel wrote:
> On 14 November 2014 16:43, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > While working on the cryptd request reordering problem, I noticed
> > an anomaly where kernel threads are normally allowed to use simd
> > per may_use_simd, but as soon as you disable softirqs, they suddenly
> > lose that ability for no good reason.
> >
> > The problem is that in_interrupt does not distinguish between
> > softirq processing and simply having softirqs disabled.  This
> > patch creates a new helper in_serving_interrupt which makes that
> > distinction.  It then uses this in all current implementations
> > of may_use_simd.
> >
> 
> Isn't that a much more widespread problem if in_interrupt() yields
> true while no interrupt is being served?

Good point.  Other users of in_interrupt() are just as likely to
really want the in_serving version.  However, the safe option is
to leave them unchanged until we audit each single one.

If it turns out that all users of in_interrupt() decay into
in_serving_interrupt() then we could remove in_interrupt().

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
