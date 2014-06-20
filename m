Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966822AbaFTSlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:41:17 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:35203 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966182AbaFTSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:41:14 -0400
Date: Sat, 21 Jun 2014 02:41:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek Vasut <marex@denx.de>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] crypto: caam: Introduce the use of the managed version
 of kzalloc
Message-ID: <20140620184105.GD3169@gondor.apana.org.au>
References: <20140527182548.GA6333@himangi-Dell>
 <201406011856.41778.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201406011856.41778.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 06:56:41PM +0200, Marek Vasut wrote:
> On Tuesday, May 27, 2014 at 08:25:48 PM, Himangi Saraogi wrote:
> > This patch moves data allocated using kzalloc to managed data allocated
> > using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> > functions.  Also, linux/device.h is added to make sure the devm_*()
> > routine declarations are unambiguously available. Earlier, in the probe
> > function ctrlpriv was leaked on the failure of ctrl = of_iomap(nprop, 0);
> > as well as on the failure of ctrlpriv->jrpdev = kzalloc(...); . These
> > two bugs have been fixed by the patch.
> > 
> > The following Coccinelle semantic patch was used for making the change:
> 
> Reviewed-by: Marek Vasut <marex@denx.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
