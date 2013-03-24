Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3CXO1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:27:06 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60029 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3CXO1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:27:04 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Date: Sun, 24 Mar 2013 15:26:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Nishanth Menon <nm@ti.com>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <517283541.62064.1362124023621.JavaMail.apache@mail81.abv.bg> <20130306175120.GP11806@atomide.com> <201303062013.16302@pali>
In-Reply-To: <201303062013.16302@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9820409.euZJscsTbO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303241526.59275@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9820409.euZJscsTbO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 06 March 2013 20:13:15 Pali Roh=C3=A1r wrote:
> On Wednesday 06 March 2013 18:51:21 Tony Lindgren wrote:
> > * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130306 06:13]:
> > > On Monday 04 March 2013 19:58:06 Tony Lindgren wrote:
> > > > * Nishanth Menon <nm@ti.com> [130301 06:42]:
> > > > > On Fri, Mar 1, 2013 at 1:47 AM, =D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=
=BE =D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2
> > >=20
> > > <freemangordon@abv.bg> wrote:
> > > > > > They look similar, but they are not equivalent :).
> > > > > > The first major difference is here (code taken from
> > > > > > omap-smc.S)
> > > > > >=20
> > > > > >> ENTRY(omap_smc2)
> > > > > >>=20
> > > > > >>          stmfd   sp!, {r4-r12, lr}
> > > > > >>          mov     r3, r2
> > > > > >>          mov     r2, r1
> > > > > >>          mov     r1, #0x0        @ Process ID
> > > > > >>          mov     r6, #0xff
> > > > > >>          mov     r12, #0x00      @ Secure Service
> > > > > >>          ID
> > > > > >=20
> > > > > > Always zero, while RX51 PPA expects a real value. I
> > > > > > wonder if it is a bug, but anyway I don't see the id
> > > > > > parameter (R0) used.
> > > > > >=20
> > > > > >>          mov     r7, #0
> > > > > >>          mcr     p15, 0, r7, c7, c5, 6
> > > > > >=20
> > > > > > According to ARM TRM, this is "Invalidate entire
> > > > > > branch predictor array"(IIUC). NFC why it is needed
> > > > > > here, but this will not work on RX-51 until IBE bit
> > > > > > in ACR is set.
> > > > > >=20
> > > > > >>          dsb
> > > > > >>          dmb
> > > > > >>          smc     #0
> > > > > >=20
> > > > > > RX-51 needs smc #1 ;)
> > > > > >=20
> > > > > >>          ldmfd   sp!, {r4-r12, pc}
> > > > > >=20
> > > > > > The next major difference is that RX-51 expects
> > > > > > parameter count passed in R3[0] to be the count of
> > > > > > the remaining parameters +1, but
> > > > > > omap_secure_dispatcher (in omap-secure.c) is passing
> > > > > > the exact count of the remaining parameters.
> > > > > >=20
> > > > > > I guess all of the above problems can be
> > > > > > fixed/workarounded, but I wonder does it worth. Not
> > > > > > to say that I don't have BB around to test if the
> > > > > > code still works if I make changes to
> > > > > > omap2-secure.c/omap-smc.S :)
> > > > >=20
> > > > > Yep, that was my point - instead of introducing new
> > > > > functions, extending the existing functions to handle
> > > > > new requirements is better solution, IMHO.
> > > >=20
> > > > I think there have been patches posted for ARM generic
> > > > SMC handling. Might be worth looking at those a bit and
> > > > see if this can be made generic. I think only the SMC
> > > > call numbering is different for various SoCs?
> > > >=20
> > > > Regards,
> > > >=20
> > > > Tony
> > >=20
> > > Hi Tony, where are patches for ARM generic SMC handling?
> >=20
> > Sorry don't have the link available, but I recall seeing
> > some patch on linux-arm-kernel within past six months that
> > added a generic smc function.. Or maybe I was dreaming or
> > something.
> >=20
> > Regards,
> >=20
> > Tony
>=20
> I am not able to find that patch...

Hi Tony,

it is possible to upstream errata 430973 workaround for RX-51?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart9820409.euZJscsTbO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFPDTMACgkQi/DJPQPkQ1KLNQCdEgRl21FJihcjkTzMoUd8PFg+
gzcAn0iHVxeRnJSQm9a5Bs6+KzvAWZjP
=V59O
-----END PGP SIGNATURE-----

--nextPart9820409.euZJscsTbO--
