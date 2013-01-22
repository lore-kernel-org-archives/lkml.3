Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3AVHGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:06:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56700 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3AVHGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:06:35 -0500
Date: Tue, 22 Jan 2013 08:06:30 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Zhang <markz@nvidia.com>, "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
Message-ID: <20130122070630.GA14728@avionic-0098.adnet.avionic-design.de>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com>
 <1358591420-7790-3-git-send-email-acourbot@nvidia.com>
 <50FD7EF9.1010205@wwwdotorg.org>
 <12033649.LY58cllSHv@percival>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <12033649.LY58cllSHv@percival>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:xJnhtAr+ZE38Ui/joACnLyNnSvrV4yX0pOiVGeUihcb
 F3QZ68dC0zpPUcrgpPuL9JOysrKGU2RFRrnCVw3O0h7Cce9ntN
 dNTsiSd3sdUHYZI30mBgf4tddj/BXe7CAtNwk2ySq2w7jR23Kr
 ZV1YRF8LYZtOmqbVNhQdPPPrv37rgPNB5hfhcmQMvmXLYu/Tut
 z+uQVnleUvshHaZO+Pq0xir3puAWguu3ta2jT74aM4PmasC5ev
 ZA9mgwO4phAraWTig72HTeJRI9OO5Fv0IoQGOV+a59UqKYlgq4
 aoN2sCHqpWO3AACvrjFnG/IS2q6MjmlmZnIUxxH04DLbJmbEsn
 YAqL0gZdZ7NluYbGMtbtlshWQUK3HhB4W0nH255sTxQHdR4k3l
 ZyK1hREIPL9+Hr2nWoaEGXEemSWXgxwqBohV00j2mLM43SZueA
 OF3m/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 12:24:34PM +0900, Alex Courbot wrote:
> On Tuesday 22 January 2013 01:46:33 Stephen Warren wrote:
> > >  arch/arm/boot/dts/tegra20-ventana.dts  |  18 +++-
> > >  arch/arm/configs/tegra_defconfig       |   1 +
> > >  drivers/video/backlight/Kconfig        |   7 ++
> > >  drivers/video/backlight/pwm_bl.c       |   3 +
> > >  drivers/video/backlight/pwm_bl_tegra.c | 159
> > >  +++++++++++++++++++++++++++++++++
> > This should be at least 3 separate patches: (1) Driver code (2) Ventana
> > .dts file (3) Tegra defconfig.
>=20
> Will do that.
>=20
> > If this is Ventana-specific, this should have a vendor prefix; "nvidia,"
> > would be appropriate.
> >=20
> > But, why is this Ventana-specific; surely it's at most panel-specific,
> > or perhaps even generic across any/most LCD panels?
>=20
> Yes, we could use the panel model here instead. Not sure how many other p=
anels=20
> follow the same powering sequence though.
>=20
> Making it Ventana-specific would have allowed to group all Tegra board su=
pport=20
> into the same driver, and considering that probably not many devices use =
the=20
> same panels as we do this seemed to make sense at first.
>=20
> > > +		power-supply =3D <&vdd_bl_reg>;
> >=20
> > "power" doesn't seem like a good regulator name; power to what? Is this
> > for the backlight, since I see there's a panel-supply below?
> >=20
> > > +		panel-supply =3D <&vdd_pnl_reg>;
> > >=20
> > > +		bl-gpio =3D <&gpio 28 0>;
> > > +		bl-panel =3D <&gpio 10 0>;
> >=20
> > GPIO names usually have "gpios" in their name, so I assume those should
> > be bl-enable-gpios, panel-enable-gpios?
>=20
> Indeed, even though there is only one gpio here. Maybe we could group the=
m=20
> into a single property and retrieve them by index - that's what the DT GP=
IO=20
> APIs seem to be designed for initially.
>=20
> > > +static struct pwm_backlight_subdriver pwm_backlight_ventana_subdrive=
r =3D {
> > > +	.name =3D "pwm-backlight-ventana",
> > > +	.init =3D init_ventana,
> > > +	.exit =3D exit_ventana,
> > > +	.notify =3D notify_ventana,
> > > +	.notify_after =3D notify_after_ventana,
> > > +};
> >=20
> > It seems like all of that code should be completely generic.
>=20
> Sorry, I don't get your point here - could you elaborate?
>=20
> > Rather than invent some new registration mechanism, if we need
> > board-/panel-/...-specific drivers, it'd be better to make each of those
> > specific drivers a full platform device in an of itself (i.e. regular
> > Linux platform device/driver, have its own probe(), etc.), and have
> > those specific drivers call into the base PWM backlight code, treating
> > it like a utility API.
>=20
> That's what would make the most sense indeed, but would require some extr=
a=20
> changes in pwm-backlight and might go against Thierry's wish to keep it=
=20
> simple. On the other hand I totally agree this would be more elegant. Eve=
ry=20
> pwm-backlight based driver would just need to invoke pwm_bl's probe/remov=
e=20
> function from its own. Thierry, would that be an acceptable alternative t=
o the=20
> sub-driver thing despite the slightly deeper changes this involves?

I'm confused. Why would you want to call into pwm_bl directly? If we're
going to split this up into separate platform devices, why not look up a
given backlight device and use the backlight API on that? The pieces of
the puzzle are all there: you can use of_find_backlight_by_node() to
obtain a backlight device from a device tree node, so I'd expect the DT
to look something like this:

	backlight: backlight {
		compatible =3D "pwm-backlight";
		...
	};

	panel: panel {
		compatible =3D "...";
		...
		backlight =3D <&backlight>;
		...
	};

After that you can wire it up with host1x using something like:

	host1x {
		dc@54200000 {
			rgb {
				status =3D "okay";

				nvidia,panel =3D <&panel>;
			};
		};
	};

Maybe with such a binding, we should move the various display-timings
properties to the panel node as well and have an API to retrieve them
for use by tegra-drm.

Thierry

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/jp2AAoJEN0jrNd/PrOhuJ0P/3FXlrooWOtNLXz6tqyW80tg
TV9NDNjR0IpvjVLXE6Voy9nWM189BqD85sc3F+b9Pq58043mJtYAC+r5zA/pdy+D
DQa/klfor5/Y+kLlJ25lWTYOWvVxiBJZ8reE5O95fco+kCRI6msGjAJKDIsbhEHj
72urT3yrVJXt5ncbcx0OWHUNlmLByWhGBx+9pzzE7aKu3X07l1P95p3Tzbbdac7V
/AafmpPdW6GeGQnRmnizmUz00PHFFYjPz3fvuAUfGSu/01a5qujJWRtVP3OA3qVc
uWolzYzbSvwJ+CE7SErMIDpWSHPCWqI2W+r6Zx/QuN5xaYddQpBiRmibLg3zfFgC
KuLmpxCcdiW1RxUucUE8Jctneh7DW306Mg6m/Qw99QXxH1RvDJUPTVOUKWDArnbh
LEskfX/WhAF8w5s3ZmGNfpfJVf8lfuYFeVeujFiXFTwkhyOSlSaJDgF9qpiN337h
Xukeku6Hx4vnzmUO5u2cxvkyRGZPcynlfjnWstLU7pBqWmqdhHTuJS7xHVvj7tsY
4uJ9BrkVIzTvFQTPMFVXKYIwA7zd8vYaMZQ+KXuD4rRfh2PDMPLZgzXKeCsweBL3
QlRYmTnzGYg6CyIo9xc4WZCqxS086vI7h/n08xIho7NYssEtvHp5iKanaNMpgAbz
xqg9vM5eT56NQuwaHceg
=vpbr
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
