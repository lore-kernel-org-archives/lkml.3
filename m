Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaFPOkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:40:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:41073 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaFPOkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:40:52 -0400
Date: Mon, 16 Jun 2014 10:40:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Torsten Duwe <duwe@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
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
        Joe Perches <joe@perches.com>,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Subject: Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device
Message-ID: <20140616144033.GC19387@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Torsten Duwe <duwe@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
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
	Joe Perches <joe@perches.com>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
References: <20140527134645.GD14099@lst.de>
 <20140527141144.GE14099@lst.de>
 <53990165.3070505@zytor.com>
 <20140612100954.GA26943@lst.de>
 <20140614024050.GA6447@thunk.org>
 <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com>
 <20140615051146.GA2180@thunk.org>
 <20140616073108.GA28232@suse.de>
 <20140616112207.GB4887@thunk.org>
 <20140616140719.GA1744@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616140719.GA1744@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:07:19PM +0200, Torsten Duwe wrote:
> > > TPM RNG is a crook ;-)
> > 
> > I think the word you mean is "crock" (as in "crock of sh*t"?)  :-)
> 
> Actually, I was thinking of a crutch. Makes you walk slowly, but better
> than nothing. Seems I've bent the wrong tube.

Heh.  One of the things that I have considered, especially for TPM, is
that in addition to having a very small quality rating, we should also
have some kind of delay so that we sleep some small amount time before
we pull from the TPM again.

Otherwise the result of using a very small quality rating is that we
end up pounding on the TPM a huge amount until the entropy pool is
above the write_wakeup threshold.  If there's some "real" use of the
TPM, such as authenticating to a wireless network, or some such, I'd
rather not be constantly pounding on the TPM if so happens that there
is a heavy drain on /dev/random at the same time that Network Manager
needs to reauthenticate to the 802.1x network.

> > manufacturer is supplying the device driver, it may not be a value
> > that other people will agree with.  Which is why I think making it
> > runtime configurable is a good thing.
> 
> Boot time configurable, I'd say. Again: this is a hardware property,
> multiplied by the admin's level of confidence in the absence of backdoors.
> It's easy with s390: from z/VM you can read all the guest's memory anyway.
> If you use this machine, you already trust IBM.

Sure, but I guess I'm a bit allergic to gazillions of boot
command-line parameters.  I guess if you are building a modular
kernel, this matters a lot less, since you can put the configs in
/etc/modprobe.d.

						- Ted
