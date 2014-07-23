Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaGWONw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:13:52 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:59779 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaGWONt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:13:49 -0400
Date: Wed, 23 Jul 2014 22:13:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek Vasut <marex@denx.de>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20140723141309.GA30324@gondor.apana.org.au>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com>
 <201405241400.03456.marex@denx.de>
 <20140723135735.GA30132@gondor.apana.org.au>
 <201407231607.21106.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201407231607.21106.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 04:07:20PM +0200, Marek Vasut wrote:
> On Wednesday, July 23, 2014 at 03:57:35 PM, Herbert Xu wrote:
> > On Sat, May 24, 2014 at 02:00:03PM +0200, Marek Vasut wrote:
> > > > +	}
> > > > +#endif
> > > > +
> > > > +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_MD5
> > > > +	err = crypto_register_shash(&sunxi_md5_alg);
> > > 
> > > Do not use shash for such device. This is clearly and ahash (and async in
> > > general) device. The rule of a thumb here is that you use sync algos only
> > > for devices which have dedicated instructions for computing the
> > > transformation. For devices which are attached to some kind of bus, you
> > > use async algos (ahash etc).
> > 
> > I'm sorry that I didn't catch this earlier but there is no such
> > rule.
> > 
> > Unless you need the async interface you should stick to the sync
> > interfaces for the sake of simplicity.
> > 
> > We have a number of existing drivers that are synchronous but
> > using the async interface.  They should either be converted
> > over to the sync interface or made interrupt-driven if possible.
> 
> Sure, but this device is interrupt driven and uses DMA to feed the crypto 
> engine, therefore async, right ?

If it's interrupt-driven, then yes it would certainly make sense to
be async.  But all I see is polling in the latest posting, was the
first version different?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
