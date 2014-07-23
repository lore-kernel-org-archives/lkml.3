Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbaGWQH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:07:58 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58416 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbaGWQHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:07:55 -0400
X-Auth-Info: Ou9mc4Hvb1wJkAzdiAIw0L9zI2anZ1j2w/+/RscdjrM=
From: Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Wed, 23 Jul 2014 17:51:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <201407231607.21106.marex@denx.de> <20140723141309.GA30324@gondor.apana.org.au>
In-Reply-To: <20140723141309.GA30324@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407231751.02050.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 at 04:13:09 PM, Herbert Xu wrote:
> On Wed, Jul 23, 2014 at 04:07:20PM +0200, Marek Vasut wrote:
> > On Wednesday, July 23, 2014 at 03:57:35 PM, Herbert Xu wrote:
> > > On Sat, May 24, 2014 at 02:00:03PM +0200, Marek Vasut wrote:
> > > > > +	}
> > > > > +#endif
> > > > > +
> > > > > +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_MD5
> > > > > +	err = crypto_register_shash(&sunxi_md5_alg);
> > > > 
> > > > Do not use shash for such device. This is clearly and ahash (and
> > > > async in general) device. The rule of a thumb here is that you use
> > > > sync algos only for devices which have dedicated instructions for
> > > > computing the transformation. For devices which are attached to some
> > > > kind of bus, you use async algos (ahash etc).
> > > 
> > > I'm sorry that I didn't catch this earlier but there is no such
> > > rule.
> > > 
> > > Unless you need the async interface you should stick to the sync
> > > interfaces for the sake of simplicity.
> > > 
> > > We have a number of existing drivers that are synchronous but
> > > using the async interface.  They should either be converted
> > > over to the sync interface or made interrupt-driven if possible.
> > 
> > Sure, but this device is interrupt driven and uses DMA to feed the crypto
> > engine, therefore async, right ?
> 
> If it's interrupt-driven, then yes it would certainly make sense to
> be async.  But all I see is polling in the latest posting, was the
> first version different?

I stand corrected then, sorry.

Is it possible to use DMA to feed the crypto accelerator, Corentin?

Best regards,
Marek Vasut
