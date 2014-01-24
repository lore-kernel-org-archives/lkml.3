Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaAXNBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:01:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58930 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaAXNBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:01:51 -0500
Date: Fri, 24 Jan 2014 13:01:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Daniel Santos <danielfsantos@att.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20140124130135.GX11727@sirena.org.uk>
References: <1388965166-27334-1-git-send-email-daniel.santos@pobox.com>
 <CAMuHMdU0FRi4=YejN+3TLJCwcptHVaaGFTLPyuwzO4NH9=-cUw@mail.gmail.com>
 <20140123181737.GA11727@sirena.org.uk>
 <52E1CE33.7040309@att.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XCIqNWEteo88hZlY"
Content-Disposition: inline
In-Reply-To: <52E1CE33.7040309@att.net>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: spidev: fix hang when transfer_one_message fails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XCIqNWEteo88hZlY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 08:21:39PM -0600, Daniel Santos wrote:
> On 01/23/2014 12:17 PM, Mark Brown wrote:
> >On Thu, Jan 23, 2014 at 05:47:02PM +0100, Geert Uytterhoeven wrote:

Please don't write enormous walls of text, it really doesn't make it
easy to read your messages or encourage doing so.  Use blank lines
between paragraphs (including within lists) and try to either split or
condense your ideas so that what you're trying to say comes over more
clearly.

> The only reason I'm using transfer_one_message() at all is because
> transfer() is being deprecated. My driver (currently out-of-tree)
> supports both but will prefer transfer() as long as it hasn't been
> removed or become broken ( which I'm managing via a #if
> LINUX_VERSION_CODE >= KERNEL_VERSION(4,99,99) check: https://github.com/daniel-santos/mcp2210-linux/blob/master/mcp2210-spi.c#L143).

No, don't do that - it's not sensible.  If there's something you need
work upstream to get it implemented or understand how to use the
framework better.  Don't code around the frameworks, talk to people
instead.

> of other spi drivers in the mainline, I can see that at least two of
> them do this as well: spi-pxa2xx and spi-bfin-v3. So perhaps we need
> a non-deprecated mechanism to do our own queuing and avoid the

No, that's not what those drivers are doing (nor the others doing
similar things) - they have done some optimisation on the code that
pushes messages to hardware so they don't defer to task context when
they don't have to.  There's very little hardware specific about what
they're doing, it's all about how we work with the scheduler to minimise
the idle time for the hardware.  A major goal of factoring out the loops
that traverse the messages from the drivers is to allow us to move that
code out of the drivers and into the framework where it belongs.

> overhead of the spi core providing a thread & queue which we'll just
> ignore. Then, the core can take care of setting status and
> finalizing when calls to transfer() fail (since there should be no
> ambiguity about this here), but leave that up to the driver when
> calling transfer_one_message()?

When the core refactoring is finished popping up into the thread will be
mostly optional.  Things like PIO, clock reprogramming and delays will
need to be pushed up into task context as do some of the DMA operations
and the completions - you don't want to be doing anything slow in
interrupt context.

--XCIqNWEteo88hZlY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4mQsAAoJELSic+t+oim99aUP/0eNOBAb/eKZUq2lSNfgoOYK
Wzsyx6Jau73lXGFwfqXGpUuKDqg0jUZumCn21aipr6gKbQW9MfaZ8wg2zQQtAtO6
jhsjls5mzZHUApjsW16R+7eOOnZZAzSUXbAw0krrVIjh+FrcFPwZH97Z4AL6fkCI
wj3GfFXaWbkKNIYBJ5CDIwqGR2ONpNJ+QIj7+i6FwzPKiuf3YecHvlZ3yV9pKsB6
XR+L8fYrm16CoYiSevCSMwwj5dcro+75K3ObU/U71f/QvnHuGJuOZJsIM84gBExI
gptZ/ZrZEVWuDMd0Elxs8NoM7bduaX8VoyyId7fPhMh4tuOFReeetxyAOTy4B+jb
fuhx0PS+s6DUwxfTKrKfAzT1aX+lleyBMrqMQqM61zqWbT3rhGiCfmb0v703J2fx
qV23GIyIaZhE2le+Y2NjXyEvICXjkPTYmlhNryC4r9eXTrzfPyfD3uTF+ocoHgj9
8AdlAbi8Ex6Hst1X3J4Py6DXLcd5Ighq8R1B7e6Knc4F0OUzoatEcQVLXRBh/3Ld
Vl6LI7xO5ezNRUBq3d2LcJpgMXOH237JvooLnB1YKcCPuOVeee2OgvRFAbRvKFle
IvH34fo/dOaHWjBQBtovjXUuvYXvUPvWvSo0+l7SaQB+ytLQ8yR5ebfwA1VNCk1B
kpAftWNd4uJxLPX8uEzq
=hxt9
-----END PGP SIGNATURE-----

--XCIqNWEteo88hZlY--
