Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbaGRJOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:14:21 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:50797 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760144AbaGRJOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:14:18 -0400
Date: Fri, 18 Jul 2014 17:14:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Amit Shah <amit.shah@redhat.com>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, keescook@chromium.org
Subject: Re: [RFC PATCH 1/3] hw_random: allow RNG devices to give early
 randomness after a delay
Message-ID: <20140718091408.GA17266@gondor.apana.org.au>
References: <cover.1405277045.git.amit.shah@redhat.com>
 <685be569a29015d3ee56cc3f782d81cae06d52b9.1405277045.git.amit.shah@redhat.com>
 <20140714123700.GP13108@titan.lakedaemon.net>
 <20140714124246.GA1520@grmbl.mre>
 <20140718085626.GA15020@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718085626.GA15020@grmbl.mre>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 02:26:26PM +0530, Amit Shah wrote:
>
> > Sounds like a good idea to me.  Though, changes in core.c that
> > increase the time in hwrng_register() or hwrng_init() may not get
> > noticed by rng drivers and they may suddenly start failing for no
> > apparent reason.  Seems like a far stretch, though.  Does anyone else
> > have an opinion on this?
> 
> Herbert, do you have any preference?

So it's only virtio-rng that's a problem, right? How about if we
abuse the scan hook in virtio and move the hwrng_register there?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
