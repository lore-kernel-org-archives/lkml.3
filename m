Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbbAUBZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 20:25:25 -0500
Received: from mail.eperm.de ([89.247.134.16]:59586 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbbAUBZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 20:25:23 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Wed, 21 Jan 2015 02:25:18 +0100
Message-ID: <40625395.stBBYbAQtz@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150120031704.GB10475@gondor.apana.org.au>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <20150120031704.GB10475@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 20. Januar 2015, 14:17:04 schrieb Herbert Xu:

Hi Tadeusz,

> On Sun, Jan 18, 2015 at 11:56:03PM +0100, Stephan Mueller wrote:
> > The cipher registered as __driver-gcm-aes-aesni is never intended
> > to be used directly by any caller. Instead it is a service mechanism to
> > rfc4106-gcm-aesni.
> > 
> > The kernel crypto API unconditionally calls the registered setkey
> > function. In case a caller erroneously uses __driver-gcm-aes-aesni a
> > call to crypto_aead_setkey will cause a NULL pointer dereference without
> > this patch.
> > 
> > CC: Tadeusz Struk <tadeusz.struk@intel.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Rather than adding a bogus setkey function, please fix this mess
> properly by moving the top-level setkey function into the __driver
> one where it should be.  Compare with how we handle it in the
> ablk_helper which is pretty much the same thing.

Tadeusz, are you working on that update or shall I have a look?

-- 
Ciao
Stephan
