Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbaGIN0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:26:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaGINZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:25:59 -0400
Date: Wed, 9 Jul 2014 18:55:24 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] hwrng: fetch randomness only after device init
Message-ID: <20140709132524.GB4667@grmbl.mre>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
 <20140709115317.GM13433@titan.lakedaemon.net>
 <20140709130822.GA4553@grmbl.mre>
 <20140709131737.GO13433@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709131737.GO13433@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 09 Jul 2014 [09:17:37], Jason Cooper wrote:
> On Wed, Jul 09, 2014 at 06:38:22PM +0530, Amit Shah wrote:
> > On (Wed) 09 Jul 2014 [07:53:17], Jason Cooper wrote:
> > > On Sat, Jul 05, 2014 at 11:04:52AM +0530, Amit Shah wrote:
> > > > Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> > > > added a call to rng_get_data() from the hwrng_register() function.
> > > > However, some rng devices need initialization before data can be read
> > > > from them.
> > > > 
> > > > This commit makes the call to rng_get_data() depend on no init fn
> > > > pointer being registered by the device.  If an init function is
> > > > registered, this call is made after device init.
> > > > 
> > > > CC: Kees Cook <keescook@chromium.org>
> > > > CC: Jason Cooper <jason@lakedaemon.net>
> > > > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > > > CC: <stable@vger.kernel.org> # For v3.15+
> > > > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > > > ---
> > > >  drivers/char/hw_random/core.c | 31 +++++++++++++++++++++++++------
> > > >  1 file changed, 25 insertions(+), 6 deletions(-)
> > > 
> > > Thanks for cleaning this up!
> > 
> > Thanks!
> > 
> > Any thoughts on the follow-up patch posted later that resolves some of
> > the weirdness in init?
> 
> hmm, I'd rather see an init function for virtio-rng that checks the bit
> and returns 0 or -EAGAIN.  With your proposed change, you would get
> hangs again.

Confused; I meant the patch in

https://lkml.org/lkml/2014/7/7/58

		Amit
