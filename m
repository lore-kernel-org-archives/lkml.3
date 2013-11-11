Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3KKJkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:40:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37059 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3KKJkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:40:10 -0500
Date: Mon, 11 Nov 2013 10:39:57 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: add support for device tree gpio control
Message-ID: <20131111093956.GI3884@ulmo.nvidia.com>
References: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com>
 <20130910172130.GC22111@ulmo>
 <523056A6.5060000@newsguy.com>
 <524408BE.40402@ti.com>
 <20130926120248.GB1680@ulmo>
 <524427E5.50403@ti.com>
 <20130926125020.GA2141@ulmo>
 <524589A3.50700@newsguy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TKDEsImF70pdVIl+"
Content-Disposition: inline
In-Reply-To: <524589A3.50700@newsguy.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TKDEsImF70pdVIl+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2013 at 06:35:31AM -0700, Mike Dunn wrote:
> On 09/26/2013 05:50 AM, Thierry Reding wrote:
> > On Thu, Sep 26, 2013 at 03:26:13PM +0300, Tomi Valkeinen wrote:
> >> On 26/09/13 15:02, Thierry Reding wrote:
> >>> On Thu, Sep 26, 2013 at 01:13:18PM +0300, Tomi Valkeinen wrote:
> >>>> On 11/09/13 14:40, Mike Dunn wrote:
> >>>>> On 09/10/2013 10:21 AM, Thierry Reding wrote:
> >>>>
> >>>>>> Do you have a real setup that actually needs multiple GPIOs? Usual=
ly
> >>>>>> such a setup requires some kind of timing or other additional cons=
traint
> >>>>>> which can't be represented by this simple binding.
> >>>>>>
> >>>>>> Looking at the Palm Treo code it seems like the reason why multiple
> >>>>>> GPIOs are needed is because one is to enable the backlight, while =
the
> >>>>>> other is in fact used to enable the LCD panel.=20
> >>>>>
> >>>>>
> >>>>> There are actually four GPIOs involved!  (There is an embarrasingly=
 horrible
> >>>>> hack in arch/arm/mach-pxa/palmtreo.c that handles the others.)  One=
 is almost
> >>>>> certainly simply backlight power.  The other three are probably LCD=
 related.
> >>>>
> >>>> When you say "power", do you mean the gpio enables a regulator to fe=
ed
> >>>> power to the backlight? If so, wouldn't that be a regulator, not gpi=
o,
> >>>> from the bl driver's point of view?
> >>>>
> >>>> Generally speaking, this same problem appears in many places, but for
> >>>> some reason especially in display. I'm a bit hesitant in adding "free
> >>>> form" gpio/regulator support for drivers, as, as Thierry pointed out,
> >>>> there are often timing requirements, or sometimes the gpios are
> >>>> inverted, or sometimes the gpio is, in fact, a reset gpio, where you=
'll
> >>>> assert the gpio for a short moment only.
> >>>
> >>> I sent out another series a few days ago that somewhat obsoletes this
> >>> patch. What it does is basically add a single enable GPIO that can be
> >>> used to turn the backlight on and off. In a separate patch, support is
> >>> added for a power regulator. The combination of both should be able to
> >>> cover the majority of use-cases.
> >>
> >> But Mike's case required 4 GPIOs? Or can that be reduced to one gpio a=
nd
> >> one regulator?
> >=20
> > Well, at least for the backlight it only seemed to involve a single
> > GPIO. The other three were probably related to LCD and therefore not
> > really suitable for a backlight driver. Traditionally it has been that
> > the backlight driver handled these things as well (via the callbacks
> > installed by board setup code). While really they should be handled by a
> > separate driver (for the LCD).
>=20
>=20
> Yes, this is currently my best guess.  This is reverse-engineered and
> unfortunately I'm not yet able to accurately describe my particular use-c=
ase.
> Probably as wacky as anything you can imagine, Thierry :)
>=20
> The gpio and regulator patches will probably suffice.  Thierry, can you p=
lease
> point me to those patches?  I don't see them in your gitorious tree.  If =
they
> were posted to linux-pwm, I missed them; sorry.

I've stumbled across this email and it's not marked as answered, so here
goes: these patches will be part of my pull request for 3.13. They
should now be in my tree, although that's now moved to kernel.org. You
can find it here:

	https://git.kernel.org/cgit/linux/kernel/git/thierry.reding/linux-pwm.git

Thierry

--TKDEsImF70pdVIl+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSgKXsAAoJEN0jrNd/PrOhHYMP/3F/glcpTv7m1AY8cAM7CLdT
OnSK+tM+5pWDgEkrTQesLireAZhmSNRte3WoJW0yOs+GZTO2F3GyPfZFaZcWkYPU
5qgNoe/1lVWYr3vUbBQ/cLh2rbLiNC33FHuac76XffEgxVV+sTeKmTlbMeB+uhfQ
7HqT4AcROMz+KxdheuFSCMjwLlahWvItsTtmFIOeBY8JiIUeHaHRKLGLR6O20Vas
OYk+rfBd7fv7f1YwVswpAUbayDrHki9KJD4c5IzZtZjzTedssKlk1pSJvRmArRd3
Mox7qSrpQLm/ovRt9fLu2hMszNtf89OAfvZmPh/HpnVmK2k4VLifiDmObP90sOUz
HBdRJJjVVTfVk4wjqWFftDa3CV+GMrHWtEH3hJGX8WNsqjU/Xw8yAt5BotwLFc4U
cvVYOnFyWZu0DxN2k+bPhJMqChjsc+7Gk3iy/gZdSB6NIC9Fzsmr7bq5Fa4sC1Ps
ptu0vN0qjLqf5C+8TKE4BbvSTfLIPQtO4xUlqEVlGvFPe13uGKMBgvpVcfOPnFz5
Sc10s6f0q/UExWjoWPduMbsZzaKfpX5137+Sm/eGgRtD5asD/SrCjTcv1/iFiuBT
fLbzHKdNqRkVUFHFWG/plCsQoLyuGuAMECX25fWZ7AppGLQwG1YLfN14TUfJfkDB
EYRiI+dZ+eFnSNXHOSJc
=WHTv
-----END PGP SIGNATURE-----

--TKDEsImF70pdVIl+--
