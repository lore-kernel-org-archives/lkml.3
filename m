Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbaDKQA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:00:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaDKQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:00:24 -0400
Date: Fri, 11 Apr 2014 09:03:12 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [crypto:master 60/60]
 arch/x86/crypto/ghash-clmulni-intel_glue.c:71:25: sparse: cast to restricted
 __be64
Message-ID: <20140411160312.GB31676@kroah.com>
References: <533aa1ae.qq4Hi3RBnPzgncue%fengguang.wu@intel.com>
 <CAKv+Gu_unwqLWWn-VDegy=vF=rprC5qFhazo_sJFNm738MVgaQ@mail.gmail.com>
 <20140401124824.GA13642@gondor.apana.org.au>
 <CAKv+Gu9bg1AgDSb3H-tMGBq53_ySaTZAeYsQeDYKS6cTnaBGUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9bg1AgDSb3H-tMGBq53_ySaTZAeYsQeDYKS6cTnaBGUA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 10:11:19AM +0200, Ard Biesheuvel wrote:
> Greg,
> 
> This pertains to commit 8ceee72808d1 (crypto: ghash-clmulni-intel -
> use C implementation for setkey()) that has been pulled by Linus
> during the current merge window.
> 
> It is missing two things:
> - a cc to stable annotation
> - a fix for the sparse warning below (change cast from __be64 to __force __be64)
> 
> The reason for cc'ing stable on this patch is that it fixes a
> potential data corruption issue where the ghash setkey() method uses
> SSE registers without calling kernel_fpu_begin() first. This issue was
> introduced by 0e1227d356e9b (crypto: ghash - Add PCLMULQDQ accelerated
> implementation).
> 
> So how would you like to proceed with this? Should I propose a new
> patch somewhere?

No problem, I'll apply this as-is.  But it doesn't apply to the
3.4-stable tree cleanly, can you send me a backported version if it's
still needed there as well?

thanks,

greg k-h
