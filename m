Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBIJVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 04:21:11 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:49983 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaBIJVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 04:21:05 -0500
Date: Sun, 9 Feb 2014 17:21:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] crypto: ccp - selective algorithm registration and
 ipsec-related fixes
Message-ID: <20140209092100.GD19429@gondor.apana.org.au>
References: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 04:17:50PM -0600, Tom Lendacky wrote:
> Patch 1: Allow for selectively disabling the registration of an algorithm
> family (sha or aes algorithms) via module parameters.
> 
> Patch 2-4: Fix errors/issues that were found during IPSec testing. In
> order to prevent deadlocks with the networking code, the crypto callback
> was changed to run as a tasklet.  In order for the callback to be run as
> a tasklet, the HMAC calculation needed to be moved out of the callback
> path (since it sleeps) and into the CCP sha operation logic.  Additionally,
> trying to allow concurrency within the tfm while maintaining serialization
> of the tfm per CPU was not working properly so a single queue is used now.
> 
> This patch series is based on the cryptodev-2.6 kernel tree.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
