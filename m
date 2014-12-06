Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaLFX1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 18:27:45 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:37781 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaLFX1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 18:27:44 -0500
Date: Sun, 7 Dec 2014 07:27:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Message-ID: <20141206232734.GA6409@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
 <20141205154606.GA30180@gondor.apana.org.au>
 <45756810.oFuGYtKPb9@tachyon.chronox.de>
 <1677221.HN3xC7fa4q@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1677221.HN3xC7fa4q@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 09:08:54PM +0100, Stephan Mueller wrote:
>
> While implementing that request, I thought about setting the auth size as part 
> of the msg control in sendmsg instead of setsockopt. This would save us a 
> system call and thus CPU cycles.

No, this is a tfm property and therefore you can't set them on the
child sockets sicne two child sockets would share the same tfm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
