Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3AVFYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:24:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3AVFYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:24:52 -0500
Date: Tue, 22 Jan 2013 16:24:34 +1100
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [RFC PATCH] Input: gpio_keys: Fix suspend/resume press event
 lost
Message-ID: <20130122162434.5bcf3e14@notabene.brown>
In-Reply-To: <20130121235718.GB16638@core.coreip.homeip.net>
References: <1358774114-8281-1-git-send-email-ivan.khoronzhuk@ti.com>
	<20130121235718.GB16638@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vXaF_GlJqM7.9kyn9AqXu+A"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vXaF_GlJqM7.9kyn9AqXu+A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Jan 2013 15:57:18 -0800 Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> Hi Ivan,
>=20
> On Mon, Jan 21, 2013 at 03:15:14PM +0200, Ivan Khoronzhuk wrote:
> > Rebased on linux_omap/master.
> >=20
> > During suspend/resume the key press can be lost if time of resume
> > sequence is significant.
> >=20
> > If press event cannot be remembered then the driver can read the
> > current button state only in time of interrupt handling. But in some
> > cases when time between IRQ and IRQ handler is significant we can
> > read incorrect state. As a particular case, when device is in suspend
> > we press wakupable key and up it back in a jiffy, the interrupt
> > handler read the state of up but the interrupt source is press indeed.
> > As a result, in a OS like android, we resume then suspend right away
> > because the key state is not changed.
> >=20
> > This patch add to gpio_keys framework opportunity to recover lost of
> > press key event at resuming. The variable "key_pressed" from
> > gpio_button_data structure is not used for gpio keys, it is only used
> > for gpio irq keys, so it is logically used to remember press lost
> > while resuming.
>=20
> The same could happen if you delay processing of interrupt long enough
> during normal operation. If key is released by the time you get around
> to reading it you will not see a key press.
>=20
> To me this sounds like you need to speed up your resume process so that
> you can start serving interrupts quicker.
>=20

Agreed.  When I was looking at this I found that any genuine button press
would have at least 70msec between press and release, while the device could
wake up to the point of being able to handle interrupts in about 14msec.
That is enough of a gap to make it pointless to try to 'fix' the code.

With enough verbose debugging enabled that 14msec can easily grow to
hundreds, but then if  you have debugging enabled to can discipline yourself
to hold the button for longer.

Ivan: What sort of delay are you seeing between the button press and the
interrupt routine running?  And can you measure how long the button is
typically down for?

NeilBrown

--Sig_/vXaF_GlJqM7.9kyn9AqXu+A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUP4ikjnsnt1WYoG5AQLovhAAuBtOrL0nol96GN+AHuxQt4PM1SrYlEMC
cLjSBx0Yj/brBp3eoRKKfaOs+MFDVzNzf8WLt5zomI84tMQ7L98jKHne3CBMkdVc
nttYhALNCMqnRzxDKA/TRZg2MYXqSlwl4Vj76HzTLxUvRvuWDw7umCWHwbeVVB+8
Y60ahWbX9oDI+s2UhOwdpB2wT0H9Aq8cMOaEwwGM3bwXRvJnkm+o0ZXmIbzoMfRh
ZVgemaJw121D6ixoj0QsnwuDvqCI+U7cNSnUef+jPVP3tqbwJ8eZJE36tBGRc6kP
dbIN+x565kmz7UwN+Cnn7zDtNTz6EjaWaG+qeh0Q3aQ+U298wtFLQTuL7mfvwUMr
+6wM1UOJi2MVzVdwHuhGRm3B+lBqUqWtGHfP9P5QEHAgJ6Jcy4+WOFs1ws3/A3nu
EMiO8k8N3GDxufFKltXJ3B2Ff6LxCUdae2rHI9AafZEBElxdorrbf0Pl40RL4nJi
YZ7oPByrafmM0DGWDy+AePxZdcHFGrokKfW9almBPILUOn/xK3n4x5A83YuQXyFd
NkRKbKucu249p391sxuRbE0jIWe/ksK660PIxmvTPONSDtznby++9tOFocvbY60M
eu6vCXRej8q32Uv3gylhLZ9TCWwBddvoqZAM+k8im75EwRBvSe3fI2cJFJ1tDtwQ
F9DcoMGJx74=
=TEVN
-----END PGP SIGNATURE-----

--Sig_/vXaF_GlJqM7.9kyn9AqXu+A--
