Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaGJIpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:45:33 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:42831 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaGJIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:45:30 -0400
Date: Thu, 10 Jul 2014 16:45:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, keescook@chromium.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio: rng: ensure reads happen after successful
 probe
Message-ID: <20140710084514.GA15418@gondor.apana.org.au>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <f64852e0dd8a439193db4c7da1d3022d029cc85d.1404538109.git.amit.shah@redhat.com>
 <20140709161836.GQ13433@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709161836.GQ13433@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:18:36PM -0400, Jason Cooper wrote:
> On Sat, Jul 05, 2014 at 11:04:53AM +0530, Amit Shah wrote:
> > The hwrng core asks for random data in the hwrng_register() call itself
> > from commit d9e7972619.  This doesn't play well with virtio -- the
> > DRIVER_OK bit is only set by virtio core on a successful probe, and
> > we're not yet out of our probe routine when this call is made.  This
> > causes the host to not acknowledge any requests we put in the virtqueue,
> > and the insmod or kernel boot process just waits for data to arrive from
> > the host, which never happens.
> > 
> > CC: Kees Cook <keescook@chromium.org>
> > CC: Jason Cooper <jason@lakedaemon.net>
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > CC: <stable@vger.kernel.org> # For v3.15+
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > ---
> >  drivers/char/hw_random/core.c       |  6 ++++++
> >  drivers/char/hw_random/virtio-rng.c | 10 ++++++++++
> >  2 files changed, 16 insertions(+)
> 
> Yeah, I don't think there's any viable way to get random data out of
> virtio-rng at probe time...  :-(
> 
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>

OK, if there are no more objections I will take these two patches.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
