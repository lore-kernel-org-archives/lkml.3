Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaJ0RJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:09:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46901 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaJ0RJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:09:19 -0400
Date: Mon, 27 Oct 2014 12:08:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
CC: <balbi@ti.com>, Johan Hovold <johan@kernel.org>,
        Romain Perier <romain.perier@gmail.com>, <devicetree@vger.kernel.org>,
        <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh@kernel.org>, <mark.rutland@arm.com>, <linux-pm@vger.kernel.org>,
        <linux@roeck-us.net>, <lee.jones@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v1 01/10] of: Rename "poweroff-source" property to
 "system-power-controller"
Message-ID: <20141027170806.GL14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <20141027164103.GD2006@localhost>
 <20141027164741.GJ14253@saruman>
 <108805117.sS9iL5zouT@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+svXpSx+RSEd8UhP"
Content-Disposition: inline
In-Reply-To: <108805117.sS9iL5zouT@diego>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+svXpSx+RSEd8UhP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 06:05:35PM +0100, Heiko St=FCbner wrote:
> Am Montag, 27. Oktober 2014, 11:47:41 schrieb Felipe Balbi:
> > On Mon, Oct 27, 2014 at 05:41:03PM +0100, Johan Hovold wrote:
> > > On Mon, Oct 27, 2014 at 11:38:40AM -0500, Felipe Balbi wrote:
> > > > On Mon, Oct 27, 2014 at 04:26:46PM +0000, Romain Perier wrote:
> > > > > As discussed on the mailing list, it makes more sense to rename t=
his
> > > > > property to "system-power-controller". Problem being that the word
> > > > > "source" usually tends to be used for inputs and that is out of
> > > > > control of the OS. The poweroff capability is an output which sim=
ply
> > > > > turns the system-power off. Also, this property might be used by
> > > > > drivers which power-off the system and power back on subsequent R=
TC
> > > > > alarms. This seems to suggest to remove "poweroff" from the prope=
rty
> > > > > name and to choose "system-power-controller" as the more generic
> > > > > name. This patchs adds the required renaming changes and defines =
an
> > > > > helper function which is compatible with both properties, the old=
 one
> > > > > prefixed by a vendor name and the new one without any prefix.
> > > >=20
> > > > I think you still need to support poweroff-source since it has been
> > > > released on a stable kernel. Perhaps add a warning message telling =
users
> > > > it's deprecated and asking them to switch over to
> > > > system-power-controller ? Still, simply removing it isn't very nice.
> > >=20
> > > No, Romain sent a patch that replaced "<vendor>,system-power-controll=
er"
> > > with "poweroff-source". It's now in Mark's tree (for v3.19), and this
> > > series "reverts" to the old name minus the vendor-prefix.
> >=20
> > oh, so poweroff-source isn't in Linus' tree yet ? (/me goes grep)
> >=20
> > Then it should be fine. My bad.
> >=20
> > Many of the other comments are still valid because even though
> > poweroff-source isn't in mainline yet, this series still creates
> > bisection points which are broken. The best solution would be to drop
> > all those patches from Mark's tree. Read, not revert, drop.
>=20
> There have never been any users of the poweroff-source. The act8846 in th=
e=20
> radxarock would have been the first, but I held off with the dts patch as=
 the=20
> naming issue came up at the same time.
>=20
> So I guess if Romain keeps the renaming together there shouldn't be any o=
ther=20
> bad bisection points?

Not build breaks, but there will always be the commit below:

commit a88f5c6deb2a44f694b01aac48231ec97059b26a
Author: Romain Perier <romain.perier@gmail.com>
Date:   Tue Oct 14 06:31:12 2014 +0000

    dt-bindings: Document the standard property "poweroff-source"
   =20
    Signed-off-by: Romain Perier <romain.perier@gmail.com>
    Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/Documentation/devicetree/bindings/power/poweroff.txt b/Documen=
tation/devicetree/bindings/power/poweroff.txt
new file mode 100644
index 0000000..845868b
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/poweroff.txt
@@ -0,0 +1,18 @@
+* Generic Poweroff capability
+
+Power-management integrated circuits or miscellaneous harware components a=
re
+sometimes able to control the system power. The device driver associated t=
o these
+components might needs to define poweroff capability, which tells to the k=
ernel
+how to switch off the system. The corresponding driver must have the stand=
ard
+property "poweroff-source" in its device node. This property marks the dev=
ice as
+able to shutdown the system. In order to test if this property is found
+programmatically, use the helper function "of_system_has_poweroff_source" =
=66rom
+of.h .
+
+Example:
+
+act8846: act8846@5 {
+	 compatible =3D "active-semi,act8846";
+	 status =3D "okay";
+	 poweroff-source;
+}

Even if for a small time frame, there will always be a commit where we
called "poweroff-source" a standard binding and, as such, as should
support it.

--=20
balbi

--+svXpSx+RSEd8UhP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnv2AAoJEIaOsuA1yqRETiEQAJO/+1AlHqC2EgvZGFWKosMh
jKdDiSbRvT65lcaxZ20qzDc4j3lgCEvMaScDHaIfr4e/JW2bpKKl9D36pD9vGhvs
ksN94eB6gjmIFO/SQkSGR9yI0NxtoE2V4Fuq3pbW7YmYRov3H4Cclx25DSC8ZmWF
mkowIAfa8MrCAh4bCsJibxArj7B/IX+ymZwRPLuSg59Avblt0P8bhH5BYZznYJJT
ihZ0jTKmiUnGWfn/f1s29McfZYTLQSPNNp6GcEZCtwEoEMX+2lywyw0etPJFYQYA
IfAdHoGeLwlHpXnHBoe3QV4dQ9Sv3WPBvrVyMuvMExxOIH3TaUr/UZP6x1prT4HY
HWcc/0+z+4RtrXfvo48lbrczG3flBwzdURF2wEmsZYaAD+jiYbbOH9E4HWFod2W7
A0BEE1+GPkIwf6MqlWC7yGoAhNSx2Z7bW0p3hVQkroGspowyKmLLPgba1tPiimaB
ahDEgH+O2S6YO8Bae22+ng3KYD80OlUQNuXfQ+VGY3GUp6TN0vmwTXLLdEuBgzyN
oVuT6ss792je4MbM3NAb1ACno3+wBndJolNcS2lwuTQb4Rn9rkJtTbsnvEK6tFra
GgYHA5ZHpyuf/EQFlXVKp1oRbbvathhlIOgCPA59NSVVYm31k/UkvjvV1Sf5qkvm
gi8ZP2P0/CgRkGutv4TH
=oNtZ
-----END PGP SIGNATURE-----

--+svXpSx+RSEd8UhP--
