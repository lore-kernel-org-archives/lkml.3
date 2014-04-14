Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaDNQCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:02:20 -0400
Received: from verein.lst.de ([213.95.11.211]:49449 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaDNQCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:02:16 -0400
Date: Mon, 14 Apr 2014 18:02:11 +0200
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v3 00/03]: hwrng: an in-kernel rngd
Message-ID: <20140414160211.GE711@lst.de>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de> <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More or less a resend of v2.

On Wed, Mar 26, 2014 at 06:03:37PM -0700, H. Peter Anvin wrote:
> I'm wondering more about the default.  We default to 50% for arch_get_random_seed, and this is supposed to be the default for in effect unverified hwrngs...

Done. 50% is now the default, that's the only change from v2.

Andy: the printk you pointed out already limits itself to 1/10s,
which is half the default rate limit. Also, as Peter already
wrote, we're dealing with true HWRNGs here; if such a device
does not produce a single byte within 10 seconds something _is_
severely broken and, like a dying disk, worth to be logged.
Here's one of the better circuits I found:
http://www.maximintegrated.com/app-notes/index.mvp/id/3469
or offline:
http://pdfserv.maximintegrated.com/en/an/AN3469.pdf
Disclaimer: I'm not endorsing Maxim, it's just that paper
that hits the spot IMHO.

Anything wrong with feeding those bits into the input pool?
Any other comments on the code?

	Torsten

