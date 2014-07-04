Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbaGDDMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:12:49 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:46392 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaGDDMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:12:47 -0400
Date: Fri, 4 Jul 2014 11:12:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Rafael Aquini <aquini@redhat.com>, aris@redhat.com,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] DRBG: fix memory corruption for AES192
Message-ID: <20140704031235.GA22340@gondor.apana.org.au>
References: <36957559.tbJt1gJF6I@myon.chronox.de>
 <3083657.SRQmeelhqi@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3083657.SRQmeelhqi@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 05:08:48PM +0200, Stephan Mueller wrote:
> For the CTR DRBG, the drbg_state->scratchpad temp buffer (i.e. the
> memory location immediately before the drbg_state->tfm variable
> is the buffer that the BCC function operates on. BCC operates
> blockwise. Making the temp buffer drbg_statelen(drbg) in size is
> sufficient when the DRBG state length is a multiple of the block
> size. For AES192 this is not the case and the length for temp is
> insufficient (yes, that also means for such ciphers, the final
> output of all BCC rounds are truncated before used to update the
> state of the DRBG!!).
> 
> The patch enlarges the temp buffer from drbg_statelen to
> drbg_statelen + drbg_blocklen to have sufficient space.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

BTW your patches were all corrupted by your mailer so I had to
fix them by hand.  Please check the cryptodev tree to ensure
that my fixes are correct.

In future please test your patches by applying your own patches
returned via the list.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
