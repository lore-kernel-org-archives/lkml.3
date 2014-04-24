Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaDXBld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:41:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaDXBl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:41:29 -0400
Date: Thu, 24 Apr 2014 11:41:15 +1000
From: NeilBrown <neilb@suse.de>
To: <balbi@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <marcel@holtmann.org>, <gustavo@padovan.org>,
        <johan.hedberg@gmail.com>, <jslaby@suse.cz>, <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140424114115.51ab3f98@notabene.brown>
In-Reply-To: <20140424012100.GB13374@saruman.home>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
	<1398265117-11793-10-git-send-email-balbi@ti.com>
	<5357DDA8.4040206@ti.com>
	<20140424084305.20c7f301@notabene.brown>
	<20140423230121.GC10924@saruman.home>
	<20140424101329.02e6a62f@notabene.brown>
	<20140424012100.GB13374@saruman.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MyFDg_Y7ohVtZhnIDuTresh"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MyFDg_Y7ohVtZhnIDuTresh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Apr 2014 20:21:00 -0500 Felipe Balbi <balbi@ti.com> wrote:

> I have no problem either way, just that unused code doesn't have to be
> sitting in the tree and I'm not entirely sure this GPIO should be
> handled by omap-serial.c, perhaps something more generic inside
> serial-core so other UART drivers can benefit from it.

Perhaps.  But there there are more people I need to convince :-)

>=20
> > On the other hand, if you can point out to me what I'm missing, and how=
 I can
> > solve my problem with any virtual GPIOs, I'm all ears.
> >=20
> > To make my problem simple and explicit:  I have a device attached to a =
UART
> > which has a separate regulator.  The regulator should be powered on if =
and
>=20
> So you're using DTR to power the GPIO and hoping that the regulator
> stabilizes quickly enough so that by the time your open() finishes you
> don't have to add nonsensical msleep() calls before writing to the
> device. Sounds a bit fragile to me.

The gpio_set call is synchronous, and the gpio-regulator driver could add a
delay (I think).


>=20
> > only if the /dev/ttyXX interface to the UART is open.  The device is a
> > bluetooth transceiver.
>=20
> considering this is a BTUART device, why didn't you do this at the ldisc
> level ? hci_uart_open() sounds like a good choice from a quick thinking.
>=20

I'll have a look into that, thanks.

NeilBrown


--Sig_/MyFDg_Y7ohVtZhnIDuTresh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1hruznsnt1WYoG5AQIoTxAAhZtt6b9GiMtK7g4jvMTBUXXlZ3k5XCK2
zDLI/LyVWwR9T+3fsWOGf6X/n57YWdOGlNNjlKw8TWXUOCquRI9j33LLF3XTO/8K
772Mffn4s1NcFzn1J4OqxcX4r4LiWnS0IH+mZKa/Hg/DLGr2tijLx+qlda8wzKTV
emq7cpHkosXpbEFFTF9seSehBiY16Xvd9iHi5La0rYFDma7nh14S6+PRjaSmmmDN
MI+2bdOH2veU7YEcngLzv21DrF4cAnF4wTCIfD86sENrJ4ezBKRD4+fFoaeh2CBq
jhjzC6FO9EqH//FoihiSuElEdZ22UHsaJNODdlID/tO+DjYCPzxGeimgYJbzV2eo
X/aMEzdrKUn/Hoeif8p21ayQ1jiAra6OLuTsrzg9ylezEfVk+KO3vsWrtoaDk4K2
q85BSzAD6SZSBCr+/vZt0ynUQLYSifG5ARbh+qWCbVkRpPWTnOIOQBvyC/+Mrkpz
eFwTouDDgMll5Iskn4oA38tgzFEck3bYb3pPjRhK+QT7uctvB5123w49qw4llTfD
0w2KeUWGFFLMyCEy/91I19x2qhMRBQqoLS73pVh74OGb5sfQFD/vfd0bJKmSzbsh
HJCiDg504o0ybFl47UkWFX8ZTshfFMUW9SCz0cbtPH53/fNfaagCERYbuYhNEj8Q
BU77UdEnt1c=
=YzD4
-----END PGP SIGNATURE-----

--Sig_/MyFDg_Y7ohVtZhnIDuTresh--
