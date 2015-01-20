Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbbATDft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:35:49 -0500
Received: from mail.eperm.de ([89.247.134.16]:59557 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbbATDfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:35:48 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Tue, 20 Jan 2015 04:35:41 +0100
Message-ID: <1490816.1NddvTAE2F@tauon>
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

Hi Herbert,

>On Sun, Jan 18, 2015 at 11:56:03PM +0100, Stephan Mueller wrote:
>> The cipher registered as __driver-gcm-aes-aesni is never intended
>> to be used directly by any caller. Instead it is a service mechanism
>> to rfc4106-gcm-aesni.
>> 
>> The kernel crypto API unconditionally calls the registered setkey
>> function. In case a caller erroneously uses __driver-gcm-aes-aesni a
>> call to crypto_aead_setkey will cause a NULL pointer dereference
>> without this patch.
>> 
>> CC: Tadeusz Struk <tadeusz.struk@intel.com>
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>
>Rather than adding a bogus setkey function, please fix this mess
>properly by moving the top-level setkey function into the __driver
>one where it should be.  Compare with how we handle it in the
>ablk_helper which is pretty much the same thing.

That is a good suggestion. And the modification is quite limited as the 
existing rfc4106_set_key could be used for the __driver with only slight 
modifications.

In that case, however, we should apply the same to rfc4106_set_authsize.

This in turn would then turn the __driver implementation into a full GCM 
implementation. That would mean that we should rename it from __driver 
into gcm(aes) / gcm-aesni. 
>
>Thanks,


Ciao
Stephan
