Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbbA0TpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:45:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:46186 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759472AbbA0TpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:45:05 -0500
Date: Tue, 27 Jan 2015 20:44:47 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Priit Laes <plaes@plaes.org>, linux-sunxi@googlegroups.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [linux-sunxi] Re: [PATCH] arm: sunxi: input: RFC: Add sysfs
 voltage for sun4i-lradc driver
Message-ID: <20150127194447.GO7200@lukather>
References: <1422291516-24895-1-git-send-email-plaes@plaes.org>
 <20150127091829.GD7200@lukather>
 <1422352189.23189.12.camel@plaes.org>
 <54C76DF2.50707@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2uzDqHpccQJpqF2n"
Content-Disposition: inline
In-Reply-To: <54C76DF2.50707@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2uzDqHpccQJpqF2n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 11:52:34AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 27-01-15 10:49, Priit Laes wrote:
> >
> >On Tue, 2015-01-27 at 10:18 +0100, Maxime Ripard wrote:
> >>Hi,
> >>
> >>On Mon, Jan 26, 2015 at 06:58:32PM +0200, Priit Laes wrote:
> >>>---
> >>
> >>Like Hans was pointing out, commit log and signed-off-by please
> >>
> >>>  .../ABI/testing/sysfs-driver-input-sun4i-lradc     |  4 ++
> >>>  drivers/input/keyboard/sun4i-lradc-keys.c          | 49
> >>>+++++++++++++++++-----
> >>>  2 files changed, 43 insertions(+), 10 deletions(-)
> >>>  create mode 100644 Documentation/ABI/testing/sysfs-driver-input-
> >>>sun4i-lradc
> >>>
> >>>diff --git a/Documentation/ABI/testing/sysfs-driver-input-sun4i-
> >>>lradc b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> >>>new file mode 100644
> >>>index 0000000..e4e6448
> >>>--- /dev/null
> >>>+++ b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> >>>@@ -0,0 +1,4 @@
> >>>+What:          /sys/class/input/input(x)/device/voltage
> >>>+Date:          February 2015
> >>>+Contact:       Priit Laes <plaes@plaes.org>
> >>>+Description:   ADC output voltage in microvolts or 0 if device is
> >>>not opened.
> >>
> >>Why is it returning 0 when "device is not opened" ? What does that
> >>even mean? You can't read that file without opening it.
> >
> >It means that something has to open the /dev/input/inputX device which
> >sets up the ADC before the voltage can be read from the sysfs file.
> >
> >[...]
> >
> >
> >>
> >>As I told you already, if you're going to expose this an ADC in the
> >>end, the proper solution is to use the IIO framework, not adding a
> >>custom sysfs file.
> >
> >My intention was to expose just a simple debug output, so one can
> >press the buttons and read the voltages for devicetree keymap.
> >
> >If anyone can suggest a simpler approach than current sysfs based one,
> >I would do it.
>=20
> The android driver always uses 0.2V / 200mV steps, so what I do is
> simply create a mapping with 200mV mapped to KEY_VOLUMEUP, 400mV mapped
> to KEY_VOLUMEDOWN, etc. following the hardcoded android driver mapping:
>=20
> https://github.com/linux-sunxi/linux-sunxi/blob/sunxi-3.4/drivers/input/k=
eyboard/sun4i-keyboard.c#L136
>=20
> Usually this will be correct in one go, after testing one can shuffle
> key codes as needed (usually not needed) and/or remove unused entries.
>=20
> With that said I do think that a sysfs file to see the actual voltages,
> or a kernel parameter to printk them on keypress interrupt would be usefu=
l.
>=20
> I guess the printk option would be better as it would show the actual
> keypress value read, not some semi-random sample.

That wouldn't require that much code actually. Either using dev_dbg,
or debugfs like Dmitry was suggesting would be two nice solutions I
guess.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2uzDqHpccQJpqF2n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx+qvAAoJEBx+YmzsjxAgZTEP+wZFHeltbLNlKcMkZRajPNv4
bFBt1MU01ao+zfcINXeBJ8YBydilRBcBavZt/+4ekTe5uXU5k6ug0RWFMz6PlXWD
l/f/NW4c2teZwJvh2D/FOzJzE0ORyj9mn7yIOPF0yqPOqvv9vpRbgffrN5wXbrpq
nK9C0s+tJJtIktBq7JnWLaHUZ7Uyd9zt7lbHQRr63Hd6KSuWH/vuWGB5ANqI2wkU
ZLuM92zJm6Vvf2CWyUMUH117qwq09C7JCcZdWlu2j49qP5hZWoXhr+Omsl6XNeYN
bPpHJ+eYE5RJw7Ib9yJveQ1qBVJXXE3F6o/ZkiuRIwqq7x5qf6IxfrROGJ4RgDsI
F/SueieVOpZENB4+oN1qfiR4p8rLzRBeweQZnngNpO0xsmeCWNf7wwkqMF2aOMyb
5TKRWsUMoKV0dnZAOBwY0HyMaKJodTyyNMktleSOfuElfNPJHjIMSBAPQwi//cXR
2QuSgqPYx3/7eKpN838ZOgLrCV2zROuAaMZywIC6S0DnwEe3x/8mj1pbN12nDXgD
Wnfqr1Z+mfVfEZBY8HBTNStQMrzq7ZuHy+P2hl+OiCRTi4e5GyL+lVAlJbSSZUXf
YR10NxOmuDjh8wIAZ3+ouIiVxLxjLGunK93ZkRp77Q5eEZTce7JBOfolf8GQ3t8w
PB2PgdQcq75+3Ab6/Myn
=Z17m
-----END PGP SIGNATURE-----

--2uzDqHpccQJpqF2n--
