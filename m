Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbaJaISs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:18:48 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:38880 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaJaISq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:18:46 -0400
Date: Fri, 31 Oct 2014 16:18:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20141031081803.GA8012@gondor.apana.org.au>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031081323.GS21251@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 09:13:23AM +0100, Maxime Ripard wrote:
>
> I don't understand here. Why would other drivers *not* being affected?
> 
> If the scatter list passed by AF_ALG can be in highmem, I guess it's
> the case for every driver out there. Almost every kernel code I've
> seen so far makes the assumption that the memory it has is mapped and
> accessible.
> 
> Somehow, it's the driver's fault now, and not the part of kernel that
> actually does the allocation?

If you are implementing a crypto driver that is meant to handle
requests from the crypto API then yes you need to handle highmem.

As I said if enough drivers are unable to address highmem and
require copying/software fallbacks then we could provide this
through the API and the driver would then only need to declare
its lack of highmem support or use a helper.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
