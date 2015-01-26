Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbbAZEfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:35:12 -0500
Received: from mail.eperm.de ([89.247.134.16]:60126 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbAZEfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:35:09 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 05:35:07 +0100
Message-ID: <13294516.zBBDkdi9pn@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150126000631.GA18350@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de> <6238416.vGUni1CI4i@tachyon.chronox.de> <20150126000631.GA18350@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 26. Januar 2015, 11:06:31 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jan 21, 2015 at 02:19:17AM +0100, Stephan Mueller wrote:
> > +	/*
> > +	 * Require exactly one IOV block as the AEAD operation is a one shot
> > +	 * due to the authentication tag.
> > +	 */
> > +	if (msg->msg_iter.nr_segs != 1)
> > +		return -ENOMSG;
> 
> Why does limit exist? The fact that you have to do it in one go does
> not limit the number of receive IOVs, at least not to one.

It seems I have misunderstood you in the last discussion.

in the last discussion [1] I tried to explain why I did not consider multiple 
IOVs. In the reply to my answer [2] I seem to have understood that the current 
implementation is fine.

So, shall I now implement the multiple IOVs approach outlined in [1]? If yes, 
how many IOVs shall I consider?
> 
> Cheers,

[1] http://www.spinics.net/lists/linux-crypto/msg12861.html

[2] http://www.spinics.net/lists/linux-crypto/msg12935.html
-- 
Ciao
Stephan
