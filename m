Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaFPHbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:31:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbaFPHbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:31:15 -0400
Date: Mon, 16 Jun 2014 09:31:08 +0200
From: Torsten Duwe <duwe@suse.de>
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
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
Message-ID: <20140616073108.GA28232@suse.de>
References: <20140415085126.GA17327@lst.de>
 <CALCETrXrHOJkEvYv8VGaNNJSFarAaD7E7G7myOvWo5SG4m4qKg@mail.gmail.com>
 <20140527134156.GA14099@lst.de>
 <20140527134645.GD14099@lst.de>
 <20140527141144.GE14099@lst.de>
 <53990165.3070505@zytor.com>
 <20140612100954.GA26943@lst.de>
 <20140614024050.GA6447@thunk.org>
 <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com>
 <20140615051146.GA2180@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615051146.GA2180@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 01:11:46AM -0400, Theodore Ts'o wrote:
> OK, I've merged these changes into the random.git tree.
> 
> I had to make a few minor changes.
> 
> 1)  Changes so it would compile on 3.15.  (random_write_wakeup_thresh
> got renamed to random_write_wakeup_bits).  I'm guessing the patch was
> massaged so that it would apply, but it was never compile tested.

I'm keeping and updating 2 versions, one -current (more or less)
and one for 3.12. I probably missed that when making the discussion changes
back and forth, sorry.

> 2)  Fixed a bug in patch #2 so that it would work correctly if the rng
> driver doesn't have an init function (which happens to be the case for
> the tpm-rng driver, which I used for my testing).

The whole thing stems from entropy-challenged s390. 3.12 on s390 compiles
and runs fine. Yields a solid 200 kB/s

TPM RNG is a crook ;-)

> There are also a few minor rough edges that I've noted, but not yet
> fixed.  The main one is that if you've compiled the hw_random's
> rng_core into the kernel, changes to
> /sys/modules/rng_core/parameters/* won't actually cause the hwrngd
> kerenl thread to get started.  You have to set the parameters before
> you load the rng module in order for them to be activated.  And if
> you've compiled the rng module into the kernel, that trick won't work.

With patch 03/03, it is up to the driver author to specify an entropy
quality, which can be overridden at boot time, or when loading
the module, respectively. This should be a constant hardware property.
It would be nice to change it at runtime; but frankly I hope that this
won't be neccessary.

> Fixing this probably means that we need to set up a formal sysfs tree
> under /sys/kernel/hw_random.

Maybe along with more sophisticated steering of how many bits to pick
from which source, if multiple are available.

Thanks,

	Torsten

