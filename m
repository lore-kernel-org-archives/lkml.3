Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaKYWHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:07:48 -0500
Received: from ozlabs.org ([103.22.144.67]:48425 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaKYWHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:07:45 -0500
Date: Wed, 26 Nov 2014 09:07:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Luc Verhaegen <libv@skynet.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
Message-ID: <20141126090737.2860d33c@canb.auug.org.au>
In-Reply-To: <5474720F.5030106@ti.com>
References: <20141117190905.4e96294a@canb.auug.org.au>
	<546B5D5A.8020304@ti.com>
	<CANq1E4SMLHmezfXSENSQ8xUaXptwA8YKQ9Nne=sDCB0gPkPLmA@mail.gmail.com>
	<5474615F.20407@ti.com>
	<5474660B.8070507@redhat.com>
	<5474720F.5030106@ti.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/dO09hQl4gnYBg1=fYuZCnCa"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dO09hQl4gnYBg1=fYuZCnCa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

On Tue, 25 Nov 2014 14:11:59 +0200 Tomi Valkeinen <tomi.valkeinen@ti.com> w=
rote:
>
> On 25/11/14 13:20, Hans de Goede wrote:
> >=20
> > On 11/25/2014 12:00 PM, Tomi Valkeinen wrote:
> >> On 18/11/14 17:07, David Herrmann wrote:
> >>>
> >>> On Tue, Nov 18, 2014 at 3:53 PM, Tomi Valkeinen
> >>> <tomi.valkeinen@ti.com> wrote:
> >>>>
> >>>> Thanks Stephen!
> >>>>
> >>>> Hans, have you had a look at this? kbuild test bot also reported thi=
s.
> >>>
> >>> The fix from Stephen should not go to main-line. It breaks simplefb on
> >>> x86 without OF. Imo, linux/clk.h should provide a fallback if OF is
> >>> not defined (like it already does for of_clk_get() and friends).
> >>>
> >>> Hans, any comments?
> >>
> >> Hans, ping.
> >=20
> > Sorry I somehow missed this thread so far, I did see the kbuild mail, b=
ut
> > it looked like a false positive to me, for the compile error case I
> > already fixed
> > in the last revision of the patch, adding #ifdef CONFIG_OF around the
> > offending code.
> >=20
> > But on closer inspection I see that the entirety of linux/clk-provider.h
> > is wrapped
> > in one huge #ifdef CONFIG_COMMON_CLK and then later on also has:
> >=20
> > #ifdef CONFIG_OF
> > ...
> > int of_clk_get_parent_count(struct device_node *np);
> > ...
> > #endif
> >=20
> > So we need both CONFIG_OF and CONFIG_COMMON_CLK, the attached patch
> > should fix this.
>=20
> Thanks, applied.

But not pushed out, yet?  Just checking that you haven't pushed on
purpose.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/dO09hQl4gnYBg1=fYuZCnCa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdP2vAAoJEMDTa8Ir7ZwVANcP/jroBargaJVzQ5TronBT2vQ9
unkJhSXtRTJQaQllboKNSTcs5UzmBh6pxGVVO0uTXVOUqjgdM57ZQ/QahPHnIaaj
YCahpnd2yezGX6njuFkNroNlZJfvESNjnUpqrfQ1aJl7dYhb7f86V8iSiyJHAHIq
aGrP5yspRkmrHAhO6yMPYR6brJ/9tn/utTZRibWcUINJNzUSg4bBNXktf9YP26lC
EGgDi7nYwppoYY2DT/TnZQKwaSCh9Ddcn7C2aD36nnYIYUPa6tXyX0vt2qd9J2Wd
2Aye72NbCrrCT+fTvIMQ7NEX2Fwhp7MgD79p7/76yHrVuUVyllxqODwqb4orPBn9
dhAvfW2NMedqo6vH7AEVJaEPnYC8o04klbn4ySbVUY1tBuS1VGqfaRK77avwI4iD
WYzYSXJjlnT7Iy81pfs9sC8+fQmtsgl4m+ftSQFruEHDegtR5kL8csbvBe4cpb+h
BbHnfO5LoCQKieD2E6oQJ9LfOZcwueIMC+h/jfbSl7ik5aBAYi5/gQkMpyGI4x1G
s82clU051HDFYvF8ya49dCp5evUL5XEjYkGVxmodx6GK2rov2Tempq4325QPqETr
p7snYlZI74pz+4lG1frU/ey7zAnScR/qQ+lXcLvXEF7lWOe4ByKE9MsGC417X5Gn
lZfJBxLl9ceiq5B5ivsE
=XpL+
-----END PGP SIGNATURE-----

--Sig_/dO09hQl4gnYBg1=fYuZCnCa--
