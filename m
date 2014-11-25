Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaKYPIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:08:42 -0500
Received: from mail.eperm.de ([89.247.134.16]:54827 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaKYPIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:08:40 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 4/7] crypto: AF_ALG: add AEAD support
Date: Tue, 25 Nov 2014 16:08:35 +0100
Message-ID: <3914952.bO8PzptSEc@tauon>
User-Agent: KMail/4.14.2 (Linux/3.17.2-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141125145850.GD8541@gondor.apana.org.au>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de> <5492722.Cc6uZ9OM2L@tauon> <20141125145850.GD8541@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. November 2014, 22:58:50 schrieb Herbert Xu:

Hi Herbert,

>On Mon, Nov 24, 2014 at 03:58:34PM +0100, Stephan Mueller wrote:
>> Ok. But in the code you see that skcipher is a 100% subset of AEAD.
>> For AEAD, all we need to do in addition to normal symmetric ciphers
>> is to select the AEAD kernel crypto API calls, to locate and use the
>> AD and to ensure we have the right memory size to process the tag.
>
>There is still one fundamental difference between AEAD and ciphers.
>Namely that ciphers can operate as you go while AEAD requests must
>be done in one lot.  So that should make the AEAD code simpler vs.
>ciphers.

Yes, that is a key difference.
>
>I think the best course of action for now is to start with sharing
>no code and then chop bits off as we see fit.

Ok, I will create a new patch set with a separate algif_aead.c. I guess 
the entire sgl handling logic will be gone in AEAD.
>
>Cheers,


Ciao
Stephan
