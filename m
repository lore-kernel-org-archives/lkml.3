Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3LKVFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:05:32 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46990 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3LKVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:05:27 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: Re: [PATCH] serial: 8250_dw: Fix LCR workaround regression
Date: Wed, 11 Dec 2013 21:05:10 +0000
Message-ID: <2515351.7napg2VnCT@radagast>
Organization: Imagination Technologies
User-Agent: KMail/4.10.5 (Linux/3.12.3+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAAYSxhr10XqQdQrvGf3Ez6e4LSbvmc0J-=yRgUePVEcd93e5wQ@mail.gmail.com>
References: <1386714484-30251-1-git-send-email-james@albanarts.com> <20131211140014.GF28456@xps8300> <CAAYSxhr10XqQdQrvGf3Ez6e4LSbvmc0J-=yRgUePVEcd93e5wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2998279.KlRiSWXGat"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2998279.KlRiSWXGat
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 11 December 2013 13:00:33 Tim Kryger wrote:
> On Wed, Dec 11, 2013 at 6:00 AM, Heikki Krogerus
> 
> <heikki.krogerus@linux.intel.com> wrote:
> > Hi,
> > 
> > On Tue, Dec 10, 2013 at 10:28:04PM +0000, James Hogan wrote:
> >> From: James Hogan <james.hogan@imgtec.com>
> >> 
> >> Commit c49436b657d0 (serial: 8250_dw: Improve unwritable LCR workaround)
> >> caused a regression. It added a check that the LCR was written properly
> >> to detect and workaround the busy quirk, but the behaviour of bit 5
> >> (UART_LCR_SPAR) differs between IP versions 3.00a and 3.14c per the
> >> docs. On older versions this caused the check to fail and it would
> >> repeatedly force idle and rewrite the LCR register, causing delays and
> >> preventing any input from serial being received.
> >> 
> >> This is fixed by masking out UART_LCR_SPAR before making the comparison.
> >> 
> >> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Jiri Slaby <jslaby@suse.cz>
> >> Cc: Tim Kryger <tim.kryger@linaro.org>
> >> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> >> Cc: Matt Porter <matt.porter@linaro.org>
> >> Cc: Markus Mayer <markus.mayer@linaro.org>
> >> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >> Tested-by: Tim Kryger <tim.kryger@linaro.org>
> >> Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > 
> > I tested this with HW without the busy functionality
> > (UART_16550_COMPATIBLE == yes). No problems here. FWIW:
> > 
> > Tested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> Greg, can you consider taking this patch as a regression fix for 3.13?
> 
> Just in case you want a little more background beyond what is in the
> commit message...
> 
> Statically declared DW UARTs will execute autoconfig_16550a during
> probe which attempts to set the SPAR bit of LCR.  Some old versions of
> the DW IP don't implement the stick parity feature and for these
> versions the SPAR bit always reads back as zero. Since these writes
> aren't fully accepted by the hardware, they trigger the workaround
> which interprets the partially rejected write to mean the UART was
> busy.  A number of attempts are made to idle the UART and re-write the
> LCR but eventually the workaround gives up and prints a warning. DT
> declared DW UARTs don't run autoconfig and don't see this issue as far
> as I know.

Hi Tim

Thanks for the extra description. FYI, I was instantiating DW UART from DT 
when I saw the problem.

Cheers
James
--nextPart2998279.KlRiSWXGat
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJSqNOTAAoJEKHZs+irPybfSsQP/jRiDTaJK0XscY6/uaU8XI9k
naSkOlGvdJJmEx89HyWnuaM/m7bgQJaY4zUFCixp33VlJw3ozPbWPx7rCAvwwaFb
Hfp5gWZDy9meYb20WgenI39YmNkNYy81ukhsS4/g2Z7VnhjUxnA4boUmxNcQjevW
TRtvdMG7Qdi9EOyJzDqlIWlTfMAVtS4scGfgDQaB0D6Y7wy+81mRNlf1HOspzK3n
67wBS4lz5631IVl5TNqdvCAaLZ9NxWexNLbQkblWcU4AnBPHxQbulKV9jAOZzZMT
uhUVAKMSfwfadQETkdWLooL04r4nAG9qnadIOjLmYyoX55NYzQzungEOZzfNE5b+
ScqXaZ7XXnydYan0fAQFQ4W6HOeeolDnWdC7LHzYdULPdRhlpyzL02gEmW+nmyG6
wxQT4/sKGWSTJ+K22SWmk4skP4YTX7VJmHX4iFyQS4K5PA2Bc5oNsR/CdokEEL/e
P18WaHFQ8tr7QHUfRX0xeHeNctL5sz3HBM5slvNVo3cVTm+zgSiJIyM/Ro9i965j
XDeqcSUGTyr88XcKIeFBjTg2te9L/g8t8h4I6+ZIg3OuIg5xBIu2aGGPhxEEky7h
NICq5VPeHAs3VbfTMSZ97Z622RNm1tCwwxj1ZaH+gJ0N2G0yMOsUKPiTR9ENrklM
/nZ5wBD2J4q/oOGEYqw8
=GIDi
-----END PGP SIGNATURE-----

--nextPart2998279.KlRiSWXGat--

