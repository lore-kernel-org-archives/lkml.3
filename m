Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaLZBBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 20:01:09 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:47952 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLZBBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 20:01:05 -0500
Date: Fri, 26 Dec 2014 12:00:56 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Subject: Re: [PATCH 3/5] hwrng: core - Do not register device
 opportunistically
Message-ID: <20141226010056.GB20702@gondor.apana.org.au>
References: <20141223053909.GA28001@gondor.apana.org.au>
 <E1Y3ICh-0007d7-SM@gondolin.me.apana.org.au>
 <87mw6egd22.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mw6egd22.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 09:59:41AM +1030, Rusty Russell wrote:
>
> Does this break userspace by creating a device which will just return
> -ENODEV on read?  Sure, callers *should* handle it...

If somebody complains we could easily fix this by making open
fail.  In fact, if such applications exist then they're likely
to want to hold onto a reference to the RNG after then open...

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
