Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaKYJAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:00:07 -0500
Received: from mail.eperm.de ([89.247.134.16]:54822 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaKYJAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:00:06 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: crypto: user - crypto_alg_match removal
Date: Tue, 25 Nov 2014 10:00:01 +0100
Message-ID: <5712678.BzXY8HRRHr@tauon>
User-Agent: KMail/4.14.2 (Linux/3.17.2-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141125084225.GY6390@secunet.com>
References: <3095384.PkgHxCg8eG@tauon> <1480327.kK94DiIqOk@tachyon.chronox.de> <20141125084225.GY6390@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. November 2014, 09:42:25 schrieb Steffen Klassert:

Hi Steffen,

>On Mon, Nov 24, 2014 at 01:29:10PM +0100, Stephan Mueller wrote:
>> Am Montag, 24. November 2014, 08:22:46 schrieb Steffen Klassert:
>> > With crypto_alg_lookup() we don't know whether the match is based
>> > on
>> > the driver or the algorithm name. That's why we have
>> > crypto_alg_match(), here we can ask for a driver or an algorithm
>> > match. In some situations it is important to have an exact match
>> > on the crypto driver name. For example if a user wants to
>> > instantiate or delete a certain inplementation of an algorithm. In
>> > this case we need to know whether this exact algorithm driver is
>> > registered in the system.
>> 
>> I understand. But going with the logic of the kernel crypto API, if
>> one needs an exact match, you pick the driver name. Otherwise the
>> generic name. crypto_alg_lookup returns the exact algo when you
>> supply a driver name. It returns the algo with the highest prio when
>> you supply a generic name.
>> 
>> I do not see a difference for the scenarios you describe.
>
>Well, I think there is a small but important difference. If a user
>requests a driver name that would match an algorithm name (i.e.
>cbc(aes) instead of cbc(aes-asm)) crypto_alg_lookup() returns the
>algorithm with the highest priority instead of telling that we don't
>have a driver with the name cbc(aes).

Agreed. If this is a use case scenario that is needed, crypto_alg_lookup 
is not suitable.

Thanks for the clarification.

Ciao
Stephan
