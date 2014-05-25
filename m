Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaEYPJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 11:09:25 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:51668 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaEYPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 11:09:24 -0400
X-Auth-Info: j2nDrbtcqnljUf9pmwwqa+3LBTHgHij8ttiiZJuQPTQ=
From: Marek Vasut <marex@denx.de>
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Sun, 25 May 2014 16:30:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.12.4; x86_64; ; )
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <201405241400.03456.marex@denx.de> <5381DAEF.20007@gmail.com>
In-Reply-To: <5381DAEF.20007@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201405251630.09753.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 25, 2014 at 01:58:39 PM, Corentin LABBE wrote:

[...]

> > This is one IP block and it provides 5 algorithms. Put it under one
> > config option please.
> 
> I want to let the user choose what it want to be used. Someone could want
> only to accelerate md5 and to not use the PRNG. Lots of other hw crypto
> driver do the same.

I don't find this useful, most users will enable all of them anyway.

> > Also, just shorted this to CONFIG_CRYPTO_SUNXI_SS , the _DEV stuff in the
> > name is useless.
> 
> I think not, most of cryptographic hardware driver begin with CRYPTO_DEV
> (CRYPTO_DEV_PADLOCK, CRYPTO_DEV_GEODE, CRYPTO_DEV_TALITOS etc...), only
> S390 does not have a _DEV.

OK. I don't mind either way.

> > [...]
> > 
> >> diff --git a/drivers/crypto/sunxi-ss.c b/drivers/crypto/sunxi-ss.c
> >> new file mode 100644
> >> index 0000000..bbf57bc
> >> --- /dev/null
> >> +++ b/drivers/crypto/sunxi-ss.c
> >> @@ -0,0 +1,1476 @@
> >> +/*
> >> + * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20
> >> SoC
> > 
> > Why can this not be generic Allwinner-all-chips driver ? Does the IP
> > block change that dramatically between the chips?
> 
> As I said in my introduction email, lots of allwinner chips seems to have
> the same crypto device. But since I do not own any of those hardware, and
> in most case does not have a datasheet, I only assume support for A20. I
> will add this comment in the header of the driver.

Can you ask others to test with other chips? Surely, you can easily prepare some 
kind of a test for others to verify on their chips.

[...]

> >> +		dev_dbg(ss_ctx->dev, "DEBUG Seed %d %x\n", i, v);
> >> +	}
> > 
> > But this debug instrumentation looks quite useless anyway.
> 
> As I said in my introduction mail, I cannot get PRNG to work, so it is the
> reason of lots of dev_dbg() Anyway, I will remove them.

Then please don't submit non-functional code for inclusion into kernel. Just 
discard the PRNG part completely until it's operational. Submit just the 
portions of code that are working please.
[...]
