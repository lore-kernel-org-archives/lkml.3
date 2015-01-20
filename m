Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbbATDyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:54:54 -0500
Received: from mail.eperm.de ([89.247.134.16]:59562 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbbATDyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:54:52 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Tue, 20 Jan 2015 04:54:44 +0100
Message-ID: <2151453.hYZ6xmSv8n@tauon>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150120033704.GB10814@gondor.apana.org.au>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <1490816.1NddvTAE2F@tauon> <20150120033704.GB10814@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 20. Januar 2015, 14:37:05 schrieb Herbert Xu:

Hi Herbert,

>On Tue, Jan 20, 2015 at 04:35:41AM +0100, Stephan Mueller wrote:
>> This in turn would then turn the __driver implementation into a full
>> GCM implementation. That would mean that we should rename it from
>> __driver into gcm(aes) / gcm-aesni.
>
>No you shouldn't because it'll fail in interrupt context where
>you cannot use those special instructions.

How would the fail manifest itself? If algif_aead would be present, user 
space could use the __driver implementation regardless of a setkey or 
authsize callback by simply calling encrypt/decrypt. Would the error be 
limited to that caller only?
>
>The whole point of this setup is to use accelerated instructions
>where possible, and otherwise fall back to a separate thread
>where we can do so safely.

Thanks for clarification.
>
>Cheers,


Ciao
Stephan
