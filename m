Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbaGINRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:17:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32946 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbaGINRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:17:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18nzaWZLbP3YbBqsIsy3COzwyrYOr5WA7c=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8C3235A68C8
Date: Wed, 9 Jul 2014 09:17:37 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] hwrng: fetch randomness only after device init
Message-ID: <20140709131737.GO13433@titan.lakedaemon.net>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
 <20140709115317.GM13433@titan.lakedaemon.net>
 <20140709130822.GA4553@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709130822.GA4553@grmbl.mre>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 06:38:22PM +0530, Amit Shah wrote:
> On (Wed) 09 Jul 2014 [07:53:17], Jason Cooper wrote:
> > On Sat, Jul 05, 2014 at 11:04:52AM +0530, Amit Shah wrote:
> > > Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> > > added a call to rng_get_data() from the hwrng_register() function.
> > > However, some rng devices need initialization before data can be read
> > > from them.
> > > 
> > > This commit makes the call to rng_get_data() depend on no init fn
> > > pointer being registered by the device.  If an init function is
> > > registered, this call is made after device init.
> > > 
> > > CC: Kees Cook <keescook@chromium.org>
> > > CC: Jason Cooper <jason@lakedaemon.net>
> > > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > > CC: <stable@vger.kernel.org> # For v3.15+
> > > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > > ---
> > >  drivers/char/hw_random/core.c | 31 +++++++++++++++++++++++++------
> > >  1 file changed, 25 insertions(+), 6 deletions(-)
> > 
> > Thanks for cleaning this up!
> 
> Thanks!
> 
> Any thoughts on the follow-up patch posted later that resolves some of
> the weirdness in init?

hmm, I'd rather see an init function for virtio-rng that checks the bit
and returns 0 or -EAGAIN.  With your proposed change, you would get
hangs again.

thx,

Jason.
