Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3A2Mav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:30:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3A2Mau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:30:50 -0500
Date: Tue, 29 Jan 2013 13:30:25 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/4] pwm_backlight: Fix PWM levels support in non DT case
Message-ID: <20130129123025.GA20166@avionic-0098.mockup.avionic-design.de>
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
 <1358861996-27194-2-git-send-email-peter.ujfalusi@ti.com>
 <20130128210123.GA24673@avionic-0098.mockup.avionic-design.de>
 <51078580.2000808@ti.com>
 <20130129101709.GC16746@avionic-0098.mockup.avionic-design.de>
 <5107BC2B.5080400@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <5107BC2B.5080400@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Gmy0FLoHggGlCABeVfMV5vYcf2ORANc6630KJaucBOM
 9KNFF6yxS8MBe+oiyVffys62gP1YtU141wKRSYYtFulRZMeOD4
 AcYZWnMBMNcw3o7fAlpLZ87UqYlSsf03LKTg9R2rEbXL85W0z9
 p2rxK0mM1yfkLfYZ7FN6Q3FYsiMEf3A/QsrqLZLDsgfwcVgZ4s
 29KsgyBYn7jbTt/WQv7urRgEbX703kRvRiZzdO1SGYChSmPApp
 q3jTpSG2oo9qt3pGNCmaw7/ODbY2XhA5ecRBweX3YZUtWoFJ2G
 T6th+X1v6rXO+sQ0uqr3oFtwg+jsoXmgKabkP8kRGmTDISKW2i
 wn668vcq7AZgEN/7kyp9Z0BsdgicQT42lW0Qa5SebuWV15JT8l
 lwSLQbakHPCtg+Hq6FCHyKaXnAQH3Cdgcc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2013 at 01:10:19PM +0100, Peter Ujfalusi wrote:
> On 01/29/2013 11:17 AM, Thierry Reding wrote:
> > On Tue, Jan 29, 2013 at 09:17:04AM +0100, Peter Ujfalusi wrote:
> >> On 01/28/2013 10:01 PM, Thierry Reding wrote:
> >>> On Tue, Jan 22, 2013 at 02:39:53PM +0100, Peter Ujfalusi wrote:
> >>>> It is expected that board files would have:
> >>>> static unsigned int bl_levels[] =3D { 0, 50, 100, 150, 200, 250, };
> >>>>
> >>>> static struct platform_pwm_backlight_data bl_data =3D {
> >>>> 	.levels =3D bl_levels,
> >>>> 	.max_brightness =3D ARRAY_SIZE(bl_levels),
> >>>> 	.dft_brightness =3D 4,
> >>>> 	.pwm_period_ns =3D 7812500,
> >>>> };
> >>>>
> >>>> In this case the max_brightness would be out of range in the levels =
array.
> >>>> Decrement the received max_brightness in every case (DT or non DT) w=
hen the
> >>>> levels has been provided.
> >>>
> >>> What's wrong with specifying .max_brightness =3D ARRAY_SIZE(bl_levels=
) - 1
> >>> instead?
> >>
> >> There is nothing wrong with that either but IMHO it is more natural fo=
r board
> >> files to use just ARRAY_SIZE(bl_levels). In this way the handling of
> >> data->max_brightness among non DT and DT booted kernel is more uniform=
 in the
> >> driver itself.
> >=20
> > The .max_brightness field is defined to be the maximum value that you
> > can set the brightness to. If you use .levels and set .max_brightness to
> > ARRAY_SIZE() then that's no longer true because the maximum value for
> > the brightness will actually be ARRAY_SIZE() - 1.
>=20
> Yes, in conjunction with .levels it would be better to have .nr_levels in=
stead
> reusing the max_brightness.
>=20
> > The reason why in the DT case we decrement .max_brightness is that it is
> > used as a temporary variable to keep the number of levels, which
> > corresponds to ARRAY_SIZE() in your example, and adjust it later on to
> > match the definition. That's an implementation detail.
> >=20
> > Platform data content should be encoded properly without knowledge of
> > the internal implementation.
> >=20
> >> Right now all board files are using only the .max_brightness to specif=
y the
> >> maximum value, I could not find any users of .levels in the kernel.
> >=20
> > Yes. But this is the legacy mode which should be considered deprecated.
> > The reason why the concept of brightness-levels was introduced back when
> > the DT bindings were created was that pretty much no hardware in
> > existence actually works that way. This was a topic of discussion at the
> > time when I first proposed these changes, see for example:
> >=20
> > 	http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg094=
72.html
>=20
> Right. Now I know the background.
> However I do not agree with the conclusion. Probably it is fine in some c=
ases
> to limit the number of configurable duty cycles to have only distinct ste=
ps.
> To not go too far, on my laptop I have:
> # cat /sys/class/backlight/acpi_video0/max_brightness
> 15
> # cat /sys/class/backlight/intel_backlight/max_brightness
> 93

FWIW, I have hardware with an Intel chipset that has max_brightness
13666. That doesn't mean all of these are necessarily valid or useful.

> In this case I would be more happier if the user space would use the
> intel_backlight than the acpi_video0. I'm fine if user space decides to a=
llow
> me only 15 distinct steps on the intel_backlight but I would expect it to=
 do
> so in a way when I change the brightness in the UI it would step down or =
up to
> the next user configurable level. Right now it uses the acpi_video0 to co=
ntrol
> the levels which means that I have (ugly) jumps in the backlight every ti=
me I
> adjust it.
>=20
> In my phone and tablet all transitions between backlight levels are smoot=
h.
> This is not a case in my laptop (with exception when the backlight is set=
 to
> auto, FW controlled).
>=20
> The perceived brightness change depends on the surrounding environment, y=
ou
> can not say that in high level you would need less steps or you need to h=
ave
> less steps in low brightness. If you in a dark room the low changes can be
> observed, while the same change when you are outside in a sunny day would=
 not
> reflect the same.
>=20
> Sure we could do the ramps in driver, but what are the parameters? how ma=
ny
> step between the two level? What is the time between the steps?
>=20
> If you are about to make a product you will end up specifying all the pos=
sible
> steps to provide the best user experience. So if the PWM have 127 duty cy=
cle
> you will have levels from 0, 1, 2, 3, ...., 125, 126, 127.

That's not true. The duty-cycle merely defines a percentage of how long
the PWM signal will be high. You can choose an arbitrary number of
subdivisions.

Since the brightness of a display isn't linearly proportional to the
duty cycle of the PWM driving it, representing that brightness by a
linear range is misleading. Furthermore some panels have regions where
the backlight isn't lit at all or where changes in the PWM duty-cycle
don't make any difference.

Thierry

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRB8DhAAoJEN0jrNd/PrOhDEQQALpWPJVCsDca1hzeNeIOWmBp
EYEWovDmtcRI1qHR8O8tsALmB4sLPF+GE7GEKQhSKlH0G4l1WSW+lez28XB3rZTX
pDP9k1bNCCnqH54YXhKmZYnSU+ZL+ueNwGYU0uZdLkSpSKv4Ed+dqM0shHNTkE3+
obRHhCzMsXo98us5E8dKCxL2xfd/NrFoWnX/pjr/y5mSnuVJim1aGZoG8ngy607o
Rj3C/tOwryvwDlZwn3gs2AngOooiyEK/qoQdHBxuD5NwvUnJ6AipZ/3ZGKlPT0+F
AI335AZVkbFwok9E2rD2qq8tFaUiGjOA1D+fDSpUUKOTU4+CVT9yIIukUUy/PHA0
Qa7v+Lw4VhuINrmputUyQLDZ3EVaHc1Z4dlbPh7Suz90y2+BNXCPA9tQOW4DdfdH
6b4yG6v+PWiAh2/FigrjF9PYBLJONJGxnAcFqG9MnW0weom2N3Pw44lJPcD2T9bV
WGXgkwbaqmUMwmSdWKAmd9hgzUmOrESxNAA+pwzgD04UcQHPJa3bhy0uXVFkEM7w
EuO+uyF/Y4Vgr/KqT6FOkKCGOwG6cnOgHGZuIL2gA/cHsdbGoT+tnN5cW6V6euLX
+y23M0NZGyNGSHMbvhzVtSCMyKdXgf6aqP9WjXmy07t136rG5AA7FYC6mjO90KNj
L7YhbdZl8Xx+tcE4uyzB
=Vn3S
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
