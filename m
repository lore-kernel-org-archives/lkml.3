Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaDKDdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 23:33:10 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:50066 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDKDdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 23:33:08 -0400
Date: Fri, 11 Apr 2014 11:32:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Porter <mporter@linaro.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>, Arnd Bergmann <arnd@arndb.de>,
        Matt Mackall <mpm@selenic.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwrng: bcm2835: fix oops when rng h/w is accessed during
 registration
Message-ID: <20140411033246.GA32231@gondor.apana.org.au>
References: <1397157730-31161-1-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397157730-31161-1-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 03:22:10PM -0400, Matt Porter wrote:
> Commit "d9e7972 hwrng: add randomness to system from rng sources"
> exposed a bug in the bcm2835-rng driver resulting in boot failure
> on Raspberry Pi due to the following oops:
> 
> [   28.261523] BUG: soft lockup - CPU#0 stuck for 23s! [swapper:1]
> [   28.271058]
> [   28.275958] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0+ #11
> [   28.285374] task: db480000 ti: db484000 task.ti: db484000
> [   28.294279] PC is at bcm2835_rng_read+0x28/0x48
> [   28.302276] LR is at hwrng_register+0x1a8/0x238
> .
> .
> .
> 
> The RNG h/w is not completely initialized and enabled before
> hwrng_register() is called and so the bcm2835_rng_read() fails.
> Fix this by making the warmup/enable writes before registering
> the RNG source with the hwrng core.
> 
> Signed-off-by: Matt Porter <mporter@linaro.org>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
