Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaFOFMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 01:12:06 -0400
Received: from imap.thunk.org ([74.207.234.97]:39381 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaFOFME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 01:12:04 -0400
Date: Sun, 15 Jun 2014 01:11:46 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Torsten Duwe <duwe@lst.de>, Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        ingo.tuchscherer@de.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device
Message-ID: <20140615051146.GA2180@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, Torsten Duwe <duwe@lst.de>,
	Andy Lutomirski <luto@amacapital.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Satoru Takeuchi <satoru.takeuchi@gmail.com>,
	ingo.tuchscherer@de.ibm.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hans-Georg Markgraf <MGRF@de.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Joe Perches <joe@perches.com>
References: <CALCETrUmFdrGExKB+tKSMVK1yWAw6KWU1tpgjnoFe=+XhJdtTw@mail.gmail.com>
 <20140415085126.GA17327@lst.de>
 <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com>
 <20140527134156.GA14099@lst.de>
 <20140527134645.GD14099@lst.de>
 <20140527141144.GE14099@lst.de>
 <53990165.3070505@zytor.com>
 <20140612100954.GA26943@lst.de>
 <20140614024050.GA6447@thunk.org>
 <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I've merged these changes into the random.git tree.

I had to make a few minor changes.

1)  Changes so it would compile on 3.15.  (random_write_wakeup_thresh
got renamed to random_write_wakeup_bits).  I'm guessing the patch was
massaged so that it would apply, but it was never compile tested.

2)  Fixed a bug in patch #2 so that it would work correctly if the rng
driver doesn't have an init function (which happens to be the case for
the tpm-rng driver, which I used for my testing).

There are also a few minor rough edges that I've noted, but not yet
fixed.  The main one is that if you've compiled the hw_random's
rng_core into the kernel, changes to
/sys/modules/rng_core/parameters/* won't actually cause the hwrngd
kerenl thread to get started.  You have to set the parameters before
you load the rng module in order for them to be activated.  And if
you've compiled the rng module into the kernel, that trick won't work.

Fixing this probably means that we need to set up a formal sysfs tree
under /sys/kernel/hw_random.

						- Ted
