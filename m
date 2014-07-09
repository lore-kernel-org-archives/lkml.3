Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaGILx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:53:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31220 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaGILxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:53:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Yepa1/ks4rvipL+L30VEB2vmz0PhhNfE=
X-DKIM: OpenDKIM Filter v2.0.1 titan C8FD95A66FA
Date: Wed, 9 Jul 2014 07:53:17 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] hwrng: fetch randomness only after device init
Message-ID: <20140709115317.GM13433@titan.lakedaemon.net>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 11:04:52AM +0530, Amit Shah wrote:
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
>  drivers/char/hw_random/core.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)

Thanks for cleaning this up!

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
