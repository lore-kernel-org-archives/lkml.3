Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaGJLNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:13:50 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42966 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaGJLNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:13:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX184lUYcNBUX04EFmF/k806iyl+Pccyn+lE=
X-DKIM: OpenDKIM Filter v2.0.1 titan C4F8F5A76FF
Date: Thu, 10 Jul 2014 07:13:38 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] hwrng: fetch randomness only after device init
Message-ID: <20140710111338.GR13433@titan.lakedaemon.net>
References: <cover.1404987133.git.amit.shah@redhat.com>
 <8cf671af94c4747765ebec91a2a4f034a65aef2e.1404987133.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cf671af94c4747765ebec91a2a4f034a65aef2e.1404987133.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 03:42:34PM +0530, Amit Shah wrote:
> Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> added a call to rng_get_data() from the hwrng_register() function.
> However, some rng devices need initialization before data can be read
> from them.
> 
> This commit makes the call to rng_get_data() depend on no init fn
> pointer being registered by the device.  If an init function is
> registered, this call is made after device init.
> 
> CC: Kees Cook <keescook@chromium.org>
> CC: Jason Cooper <jason@lakedaemon.net>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: <stable@vger.kernel.org> # For v3.15+
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/char/hw_random/core.c | 41 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 33 insertions(+), 8 deletions(-)

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
