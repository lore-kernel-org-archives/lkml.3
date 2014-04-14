Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaDNQOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:14:07 -0400
Received: from verein.lst.de ([213.95.11.211]:49566 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbaDNQOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:14:02 -0400
Date: Mon, 14 Apr 2014 18:13:59 +0200
From: Torsten Duwe <duwe@lst.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg Price <price@mit.edu>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 0/2] random: Use DRBG sources
Message-ID: <20140414161359.GD29351@lst.de>
References: <cover.1397487345.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1397487345.git.luto@amacapital.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 08:49:58AM -0700, Andy Lutomirski wrote:
> [Resent because I forgot to email lkml.  This also surreptitiously
>  fixes a silly typo on a patch description.]
> 
> This is my attempt to come up with a workable way to use so-called
> entropy sources like a TPM to feed /dev/urandom.

Ahem, The TPM RNGs are true HWRNGs, but they are very limited.
Their main purpose is to generate enough bits so that the TPM
can generate a genuine key pair after a few seconds.

Why do you want to put those valuable true random bits into urandom?

> Arguably we should be feeding the input pool as well, but if the

Yes.

> /dev/random algorithm is correct, this shouldn't matter.  I don't want
> sensible use of TPMs for /dev/urandom to block on a long debate about
> /dev/random, so these patches have no effect on /dev/random.

That confuses me a bit.

	Torsten

