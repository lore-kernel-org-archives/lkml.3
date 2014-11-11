Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaKKERE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:17:04 -0500
Received: from mail.eperm.de ([89.247.134.16]:54320 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaKKERB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:17:01 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: crypto: zeroization of sensitive data in af_alg
Date: Tue, 11 Nov 2014 05:16:54 +0100
Message-ID: <3021915.VU7Ypy9It6@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CACXcFmmp=SMisc0p-Fx=M3myXE0E-kH3zN6NGrODeVzQrXUdFA@mail.gmail.com>
References: <1979092.odOtqL46qU@tachyon.chronox.de> <CACXcFmmp=SMisc0p-Fx=M3myXE0E-kH3zN6NGrODeVzQrXUdFA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 10. November 2014, 21:55:43 schrieb Sandy Harris:

Hi Sandy, Herbert,

> On Sun, Nov 9, 2014 at 5:33 PM, Stephan Mueller <smueller@chronox.de> wrote:
> > while working on the AF_ALG interface, I saw no active zeroizations of
> > memory that may hold sensitive data that is maintained outside the kernel
> > crypto API cipher handles. ...
> > 
> > I think I found the location for the first one: hash_sock_destruct that
> > should be enhanced with a memset(0) of ctx->result.
> 
> See also a thread titled "memset() in crypto code?" on the linux
> crypto list. The claim is that gcc can optimise memset() away so you
> need a different function to guarantee the intended results. There's a
> patch to the random driver that uses a new function
> memzero_explicit(), and one of the newer C standards has a different
> function name for the purpose.

That is a good idea.

Herbert: I can prepare a patch that uses memzero_explicit. However, your 
current tree does not yet implement that function as it was added to Linus' 
tree after you pulled from it.

Shall I now still use memset(0) or prepare a patch that does not yet compile 
by using memzero_explicit?

-- 
Ciao
Stephan
