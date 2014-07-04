Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbaGDDhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:37:48 -0400
Received: from mail.eperm.de ([89.247.134.16]:37965 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbaGDDhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:37:47 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rafael Aquini <aquini@redhat.com>, aris@redhat.com,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] DRBG: fix memory corruption for AES192
Date: Fri, 04 Jul 2014 05:36:03 +0200
Message-ID: <5854363.JdQPrZ9a72@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140704031235.GA22340@gondor.apana.org.au>
References: <36957559.tbJt1gJF6I@myon.chronox.de> <3083657.SRQmeelhqi@myon.chronox.de> <20140704031235.GA22340@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Juli 2014, 11:12:35 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Jul 01, 2014 at 05:08:48PM +0200, Stephan Mueller wrote:
> > For the CTR DRBG, the drbg_state->scratchpad temp buffer (i.e. the
> > memory location immediately before the drbg_state->tfm variable
> > is the buffer that the BCC function operates on. BCC operates
> > blockwise. Making the temp buffer drbg_statelen(drbg) in size is
> > sufficient when the DRBG state length is a multiple of the block
> > size. For AES192 this is not the case and the length for temp is
> > insufficient (yes, that also means for such ciphers, the final
> > output of all BCC rounds are truncated before used to update the
> > state of the DRBG!!).
> > 
> > The patch enlarges the temp buffer from drbg_statelen to
> > drbg_statelen + drbg_blocklen to have sufficient space.
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> BTW your patches were all corrupted by your mailer so I had to
> fix them by hand.  Please check the cryptodev tree to ensure
> that my fixes are correct.

The patch fixing the memory corruption is completely and correctly applied.

Apologies for sending broken patches. If I shall resend them corrected, please 
let me know.
> 
> In future please test your patches by applying your own patches
> returned via the list.

I will do that.

-- 
Ciao
Stephan
