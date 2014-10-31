Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbaJaHAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:00:17 -0400
Received: from ozlabs.org ([103.22.144.67]:52786 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbaJaHAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:00:16 -0400
Message-ID: <1414738812.21815.5.camel@concordia>
Subject: Re: [PATCH] hwrng: pseries - port to new read API and fix stack
 corruption
From: Michael Ellerman <mpe@ellerman.id.au>
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Date: Fri, 31 Oct 2014 18:00:12 +1100
In-Reply-To: <20141031063233.1884.86309.stgit@bahia.local>
References: <20141031063233.1884.86309.stgit@bahia.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 07:50 +0100, Greg Kurz wrote:
> The add_early_randomness() function in drivers/char/hw_random/core.c passes
> a 16-byte buffer to pseries_rng_data_read(). Unfortunately, plpar_hcall()
> returns four 64-bit values and trashes 16 bytes on the stack.

Hmm, thanks. I thought I'd fixed that, but I guess I never sent the patch :}

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

Well probably, can you do a before and after test of dd if=/dev/hwrng ?

> Cc'ing stable as I could reproduce back to 3.15.10

The right way to CC stable for a patch that isn't yet in upstream is to add:

CC: stable@vger.kernel.org

Before your Signed-off-by. They will then pick it up once it's merged into
Linus' tree. See Documentation/stable_kernel_rules.txt

cheers


