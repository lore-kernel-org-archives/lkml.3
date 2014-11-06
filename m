Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaKFPOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:14:03 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:54460 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaKFPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:13:48 -0500
Date: Thu, 6 Nov 2014 23:13:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: pseries - port to new read API and fix stack
 corruption
Message-ID: <20141106151338.GB4446@gondor.apana.org.au>
References: <20141031063233.1884.86309.stgit@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031063233.1884.86309.stgit@bahia.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 07:50:11AM +0100, Greg Kurz wrote:
> The add_early_randomness() function in drivers/char/hw_random/core.c passes
> a 16-byte buffer to pseries_rng_data_read(). Unfortunately, plpar_hcall()
> returns four 64-bit values and trashes 16 bytes on the stack.
> 
> This bug has been lying around for a long time. It got unveiled by:
> 
> commit d3cc7996473a7bdd33256029988ea690754e4e2a
> Author: Amit Shah <amit.shah@redhat.com>
> Date:   Thu Jul 10 15:42:34 2014 +0530
> 
>     hwrng: fetch randomness only after device init
> 
> It may trig a oops while loading or unloading the pseries-rng module for both
> PowerVM and PowerKVM guests.
> 
> This patch does two things:
> - pass an intermediate well sized buffer to plpar_hcall(). This is acceptalbe
>   since we're not on a hot path.
> - move to the new read API so that we know the return buffer size for sure.
> 
> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>

Patch applied to crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
